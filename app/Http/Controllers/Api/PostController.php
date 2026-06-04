<?php

namespace App\Http\Controllers\Api;

use App\Events\AnswerAccepted;
use App\Events\PostCreated;
use App\Http\Controllers\Controller;
use App\Http\Requests\StorePostRequest;
use App\Http\Requests\UpdatePostRequest;
use App\Http\Resources\PostResource;
use App\Models\Bookmark;
use App\Models\Comment;
use App\Models\Like;
use App\Models\Post;
use App\Models\PostEditHistory;
use App\Models\Vote;
use App\Notifications\AnswerAcceptedNotification;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;

class PostController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        try {
            $query = Post::with(['user:id,username,avatar_url', 'category:id,name,slug', 'tags:id,name,slug,color']);

            if ($request->filled('search')) {
                $ids = Post::search($request->search)->get()->pluck('id');
                $query->whereIn('id', $ids);
            }

            if ($request->filled('category')) {
                $query->whereHas('category', fn ($q) => $q->where('slug', $request->category));
            }

            if ($request->filled('tag')) {
                $query->whereHas('tags', fn ($q) => $q->where('slug', $request->tag));
            }

            if ($request->filled('user')) {
                $query->where('user_id', $request->user);
            }

            if ($request->filled('status')) {
                $query->where('status', $request->status);
            }

            $sortField = $request->sort ?? 'created_at';
            $sortDir = $request->order ?? 'desc';
            $query->orderBy($sortField, $sortDir);

            $posts = $query->paginate($request->per_page ?? 15);

            return $this->resource(PostResource::collection($posts));
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function store(StorePostRequest $request): JsonResponse
    {
        try {
            $post = DB::transaction(function () use ($request) {
                $post = Post::create([
                    'user_id' => $request->user()->id,
                    'category_id' => $request->category_id,
                    'title' => $request->title,
                    'body' => $request->body,
                ]);

                if ($request->filled('tags')) {
                    $post->tags()->sync($request->tags);
                }

                return $post;
            });

            $post->load(['user:id,username,avatar_url', 'category:id,name,slug', 'tags:id,name,slug,color']);

            PostCreated::dispatch($post);

            return $this->resource(new PostResource($post), 'Post berhasil dibuat', 201);
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function show(Request $request, string $id): JsonResponse
    {
        try {
            $post = Cache::remember("post_{$id}", 600, function () use ($id) {
                return Post::with([
                    'user:id,username,avatar_url,reputation_points',
                    'category:id,name,slug',
                    'tags:id,name,slug,color',
                    'acceptedAnswer',
                ])->withCount(['comments', 'bookmarks'])->findOrFail($id);
            });

            $post->load([
                'comments' => function ($q) {
                    $q->whereNull('parent_id')
                        ->with(['user:id,username,avatar_url', 'replies' => function ($q) {
                            $q->with('user:id,username,avatar_url');
                        }]);
                },
            ]);

            Post::withoutEvents(function () use ($post) {
                $post->increment('view_count');
            });

            if ($user = $request->user('sanctum')) {
                $post->setAttribute('user_vote', Vote::where('user_id', $user->id)->where('target_id', $post->id)->where('target_type', 'post')->value('vote_type'));
                $post->setAttribute('user_liked', Like::where('user_id', $user->id)->where('target_id', $post->id)->where('target_type', 'post')->exists());
                $post->setAttribute('is_bookmarked', Bookmark::where('user_id', $user->id)->where('post_id', $post->id)->exists());
            }

            return $this->resource(new PostResource($post));
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function update(UpdatePostRequest $request, string $id): JsonResponse
    {
        try {
            $post = Post::findOrFail($id);

            $user = $request->user();
            $isOwner = $post->user_id === $user->id;
            $isModerator = $user->roles->contains(fn ($r) => in_array($r->name, ['admin', 'moderator']));

            if (! $isOwner && ! $isModerator) {
                return $this->forbidden();
            }

            $data = $request->only(['title', 'body', 'category_id']);

            DB::transaction(function () use ($request, $post, $data) {
                if ($request->filled('body') && $request->body !== $post->body) {
                    PostEditHistory::create([
                        'post_id' => $post->id,
                        'edited_by' => $request->user()->id,
                        'body_before' => $post->body,
                        'body_after' => $request->body,
                        'reason' => $request->reason,
                    ]);
                }

                $post->update($data);

                if ($request->has('tags')) {
                    $post->tags()->sync($request->tags ?? []);
                }
            });

            $post->fresh()->load(['user:id,username,avatar_url', 'category:id,name,slug', 'tags:id,name,slug,color']);

            return $this->resource(new PostResource($post), 'Post berhasil diperbarui');
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function destroy(Request $request, string $id): JsonResponse
    {
        try {
            $post = Post::findOrFail($id);

            $user = $request->user();
            $isOwner = $post->user_id === $user->id;
            $isModerator = $user->roles->contains(fn ($r) => in_array($r->name, ['admin', 'moderator']));

            if (! $isOwner && ! $isModerator) {
                return $this->forbidden();
            }

            $post->update(['status' => 'deleted']);

            return $this->ok(null, 'Post berhasil dihapus');
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function acceptAnswer(Request $request, string $postId, string $commentId): JsonResponse
    {
        try {
            $post = Post::findOrFail($postId);

            if ($post->user_id !== $request->user()->id) {
                return $this->forbidden('Hanya pemilik post yang bisa accept answer');
            }

            $comment = Comment::where('id', $commentId)->where('post_id', $postId)->firstOrFail();

            DB::transaction(function () use ($post, $comment) {
                if ($post->accepted_answer_id) {
                    Comment::where('id', $post->accepted_answer_id)->update(['is_accepted' => false]);
                }

                $post->update(['accepted_answer_id' => $comment->id, 'is_answered' => true]);
                $comment->update(['is_accepted' => true]);
            });

            AnswerAccepted::dispatch($post, $comment);

            if ($comment->user_id !== $post->user_id) {
                $comment->user->notify(new AnswerAcceptedNotification(
                    $request->user(),
                    $post->id,
                    $post->title,
                ));
            }

            return $this->ok(null, 'Jawaban diterima');
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function toggleBookmark(Request $request, string $id): JsonResponse
    {
        try {
            $post = Post::findOrFail($id);

            $existing = Bookmark::where('user_id', $request->user()->id)
                ->where('post_id', $id)
                ->first();

            if ($existing) {
                $existing->delete();

                return $this->ok(['is_bookmarked' => false], 'Bookmark dihapus');
            }

            Bookmark::create([
                'user_id' => $request->user()->id,
                'post_id' => $id,
            ]);

            return $this->ok(['is_bookmarked' => true], 'Post di-bookmark');
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function history(string $id): JsonResponse
    {
        try {
            $post = Post::findOrFail($id);

            $histories = $post->editHistories()
                ->with('editor:id,username')
                ->orderBy('edited_at', 'desc')
                ->get();

            return $this->ok($histories);
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }
}
