<?php

namespace App\Http\Controllers\Api;

use App\Events\CommentCreated;
use App\Http\Controllers\Controller;
use App\Http\Requests\StoreCommentRequest;
use App\Http\Requests\UpdateCommentRequest;
use App\Http\Resources\CommentResource;
use App\Models\Comment;
use App\Models\CommentEditHistory;
use App\Models\Post;
use App\Notifications\CommentNotification;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Notification;

class CommentController extends Controller
{
    public function index(string $postId): JsonResponse
    {
        try {
            $post = Post::findOrFail($postId);

            $comments = $post->comments()
                ->whereNull('parent_id')
                ->with(['user:id,username,avatar_url', 'replies' => function ($q) {
                    $q->with('user:id,username,avatar_url')->oldest();
                }])
                ->withCount('replies')
                ->oldest()
                ->get();

            return $this->resource(CommentResource::collection($comments));
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function store(StoreCommentRequest $request, string $postId): JsonResponse
    {
        try {
            $post = Post::findOrFail($postId);

            $comment = Comment::create([
                'post_id' => $post->id,
                'user_id' => $request->user()->id,
                'parent_id' => $request->parent_id,
                'body' => $request->body,
            ]);

            $comment->load('user:id,username,avatar_url');

            CommentCreated::dispatch($comment);

            if ($post->user_id !== $request->user()->id) {
                Notification::send($post->user, new CommentNotification(
                    $request->user(),
                    $post->id,
                    $post->title,
                ));
            }

            return $this->resource(new CommentResource($comment), 'Komentar berhasil ditambahkan', 201);
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function update(UpdateCommentRequest $request, string $id): JsonResponse
    {
        try {
            $comment = Comment::findOrFail($id);

            $user = $request->user();
            $isOwner = $comment->user_id === $user->id;
            $isModerator = $user->roles->contains(fn ($r) => in_array($r->name, ['admin', 'moderator']));

            if (! $isOwner && ! $isModerator) {
                return $this->forbidden();
            }

            if ($request->filled('body') && $request->body !== $comment->body) {
                CommentEditHistory::create([
                    'comment_id' => $comment->id,
                    'edited_by' => $user->id,
                    'body_before' => $comment->body,
                    'body_after' => $request->body,
                ]);
            }

            $comment->update($request->only('body'));

            return $this->resource(new CommentResource($comment->fresh()->load('user:id,username,avatar_url')), 'Komentar diperbarui');
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function destroy(Request $request, string $id): JsonResponse
    {
        try {
            $comment = Comment::findOrFail($id);

            $user = $request->user();
            $isOwner = $comment->user_id === $user->id;
            $isModerator = $user->roles->contains(fn ($r) => in_array($r->name, ['admin', 'moderator']));

            if (! $isOwner && ! $isModerator) {
                return $this->forbidden();
            }

            $comment->delete();

            return $this->ok(null, 'Komentar dihapus');
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function history(Request $request, string $id): JsonResponse
    {
        try {
            $comment = Comment::findOrFail($id);

            $user = $request->user();
            $isOwner = $comment->user_id === $user->id;
            $isModerator = $user->roles->contains(fn ($r) => in_array($r->name, ['admin', 'moderator']));

            if (! $isOwner && ! $isModerator) {
                return $this->forbidden();
            }

            $histories = $comment->editHistories()
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
