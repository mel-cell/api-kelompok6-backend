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
use OpenApi\Attributes as OA;

class PostController extends Controller
{
    #[OA\Get(
        path: '/api/v1/posts',
        summary: 'Daftar semua post',
        tags: ['Posts']
    )]
    #[OA\Parameter(name: 'search', in: 'query', required: false, schema: new OA\Schema(type: 'string'))]
    #[OA\Parameter(name: 'category', in: 'query', required: false, schema: new OA\Schema(type: 'string'))]
    #[OA\Parameter(name: 'tag', in: 'query', required: false, schema: new OA\Schema(type: 'string'))]
    #[OA\Parameter(name: 'sort', in: 'query', required: false, schema: new OA\Schema(type: 'string', enum: ['created_at', 'title', 'view_count', 'vote_score']))]
    #[OA\Parameter(name: 'order', in: 'query', required: false, schema: new OA\Schema(type: 'string', enum: ['asc', 'desc']))]
    #[OA\Parameter(name: 'per_page', in: 'query', required: false, schema: new OA\Schema(type: 'integer', default: 15))]
    #[OA\Response(
        response: 200,
        description: 'Daftar post berhasil diambil',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Berhasil'),
                new OA\Property(property: 'data', type: 'array', items: new OA\Items(ref: '#/components/schemas/Post')),
                new OA\Property(property: 'meta', properties: [
                    new OA\Property(property: 'current_page', type: 'integer'),
                    new OA\Property(property: 'last_page', type: 'integer'),
                    new OA\Property(property: 'per_page', type: 'integer'),
                    new OA\Property(property: 'total', type: 'integer'),
                ]),
                new OA\Property(property: 'links', properties: [
                    new OA\Property(property: 'first', type: 'string'),
                    new OA\Property(property: 'last', type: 'string'),
                    new OA\Property(property: 'prev', type: 'string', nullable: true),
                    new OA\Property(property: 'next', type: 'string', nullable: true),
                ]),
            ]
        )
    )]
    public function index(Request $request): JsonResponse
    {
        try {
            $query = Post::with(['user:id,username,avatar_url', 'category:id,name,slug', 'tags:id,name,slug,color']);

            if ($request->filled('search')) {
                $ids = Post::search($request->search)->get()->pluck('id');
                $query->whereIn('id', $ids);
            }

            $category = $request->input('filter.category', $request->category);
            if ($category) {
                $query->whereHas('category', fn ($q) => $q->where('slug', $category));
            }

            $tag = $request->input('filter.tag', $request->tag);
            if ($tag) {
                $query->whereHas('tags', fn ($q) => $q->where('slug', $tag));
            }

            if ($request->filled('user')) {
                $query->where('user_id', $request->user);
            }

            if ($request->filled('status')) {
                $query->where('status', $request->status);
            }

            if ($request->boolean('bookmarked')) {
                $user = $request->user('sanctum');
                if ($user) {
                    $query->whereHas('bookmarks', fn ($q) => $q->where('user_id', $user->id));
                }
            }

            $allowedSorts = ['created_at', 'title', 'view_count', 'vote_score'];
            $sortField = in_array($request->sort, $allowedSorts) ? $request->sort : 'created_at';
            $sortDir = strtolower($request->order ?? '') === 'asc' ? 'asc' : 'desc';
            $query->orderBy($sortField, $sortDir);

            $posts = $query->paginate($request->per_page ?? 15);

            return $this->resource(PostResource::collection($posts));
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    #[OA\Post(
        path: '/api/v1/posts',
        summary: 'Buat post baru',
        security: [['bearerAuth' => []]],
        tags: ['Posts']
    )]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            required: ['category_id', 'title', 'body'],
            properties: [
                new OA\Property(property: 'category_id', type: 'string', format: 'uuid'),
                new OA\Property(property: 'title', type: 'string', example: 'Cara menggunakan Laravel'),
                new OA\Property(property: 'body', type: 'string', example: 'Penjelasan lengkap...'),
                new OA\Property(property: 'tags', type: 'array', items: new OA\Items(type: 'string', format: 'uuid')),
            ]
        )
    )]
    #[OA\Response(
        response: 201,
        description: 'Post berhasil dibuat',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Post berhasil dibuat'),
                new OA\Property(property: 'data', ref: '#/components/schemas/Post'),
            ]
        )
    )]
    #[OA\Response(
        response: 401,
        description: 'Tidak terautentikasi',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Tidak terautentikasi'),
            ]
        )
    )]
    #[OA\Response(
        response: 422,
        description: 'Validasi gagal',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Validasi gagal'),
                new OA\Property(property: 'errors', type: 'object'),
            ]
        )
    )]
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

    #[OA\Get(
        path: '/api/v1/posts/{id}',
        summary: 'Detail post',
        tags: ['Posts']
    )]
    #[OA\Parameter(name: 'id', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\Response(
        response: 200,
        description: 'Detail post berhasil diambil',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Berhasil'),
                new OA\Property(property: 'data', ref: '#/components/schemas/Post'),
            ]
        )
    )]
    #[OA\Response(
        response: 404,
        description: 'Post tidak ditemukan',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Data tidak ditemukan'),
            ]
        )
    )]
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

    #[OA\Put(
        path: '/api/v1/posts/{id}',
        summary: 'Update post (pemilik atau moderator)',
        security: [['bearerAuth' => []]],
        tags: ['Posts']
    )]
    #[OA\Parameter(name: 'id', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'title', type: 'string'),
                new OA\Property(property: 'body', type: 'string'),
                new OA\Property(property: 'category_id', type: 'string', format: 'uuid'),
                new OA\Property(property: 'reason', type: 'string'),
            ]
        )
    )]
    #[OA\Response(
        response: 200,
        description: 'Post berhasil diperbarui',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Post berhasil diperbarui'),
                new OA\Property(property: 'data', ref: '#/components/schemas/Post'),
            ]
        )
    )]
    #[OA\Response(
        response: 403,
        description: 'Akses ditolak',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Tidak memiliki akses'),
            ]
        )
    )]
    #[OA\Response(
        response: 404,
        description: 'Post tidak ditemukan',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Data tidak ditemukan'),
            ]
        )
    )]
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

    #[OA\Delete(
        path: '/api/v1/posts/{id}',
        summary: 'Hapus post (pemilik atau moderator)',
        security: [['bearerAuth' => []]],
        tags: ['Posts']
    )]
    #[OA\Parameter(name: 'id', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\Response(
        response: 200,
        description: 'Post berhasil dihapus',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Post berhasil dihapus'),
            ]
        )
    )]
    #[OA\Response(
        response: 403,
        description: 'Akses ditolak',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Tidak memiliki akses'),
            ]
        )
    )]
    #[OA\Response(
        response: 404,
        description: 'Post tidak ditemukan',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Data tidak ditemukan'),
            ]
        )
    )]
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

    #[OA\Patch(
        path: '/api/v1/posts/{postId}/accept/{commentId}',
        summary: 'Tandai komentar sebagai jawaban diterima',
        security: [['bearerAuth' => []]],
        tags: ['Posts']
    )]
    #[OA\Parameter(name: 'postId', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\Parameter(name: 'commentId', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\Response(
        response: 200,
        description: 'Jawaban diterima',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Jawaban diterima'),
            ]
        )
    )]
    #[OA\Response(
        response: 403,
        description: 'Hanya pemilik post',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Hanya pemilik post yang bisa accept answer'),
            ]
        )
    )]
    #[OA\Response(
        response: 404,
        description: 'Post atau komentar tidak ditemukan',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Data tidak ditemukan'),
            ]
        )
    )]
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

    #[OA\Post(
        path: '/api/v1/posts/{id}/bookmark',
        summary: 'Toggle bookmark post',
        security: [['bearerAuth' => []]],
        tags: ['Posts']
    )]
    #[OA\Parameter(name: 'id', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\Response(
        response: 200,
        description: 'Status bookmark berubah',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Bookmark dihapus'),
                new OA\Property(property: 'data', properties: [
                    new OA\Property(property: 'is_bookmarked', type: 'boolean', example: false),
                ]),
            ]
        )
    )]
    #[OA\Response(
        response: 404,
        description: 'Post tidak ditemukan',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Data tidak ditemukan'),
            ]
        )
    )]
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

    #[OA\Get(
        path: '/api/v1/posts/{id}/history',
        summary: 'Riwayat edit post (pemilik atau moderator)',
        security: [['bearerAuth' => []]],
        tags: ['Posts']
    )]
    #[OA\Parameter(name: 'id', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\Response(
        response: 200,
        description: 'Riwayat edit post',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Berhasil'),
                new OA\Property(property: 'data', type: 'array', items: new OA\Items(
                    properties: [
                        new OA\Property(property: 'id', type: 'string', format: 'uuid'),
                        new OA\Property(property: 'body_before', type: 'string'),
                        new OA\Property(property: 'body_after', type: 'string'),
                        new OA\Property(property: 'reason', type: 'string', nullable: true),
                        new OA\Property(property: 'edited_at', type: 'string', format: 'date-time'),
                        new OA\Property(property: 'editor', properties: [
                            new OA\Property(property: 'id', type: 'string', format: 'uuid'),
                            new OA\Property(property: 'username', type: 'string'),
                        ]),
                    ]
                )),
            ]
        )
    )]
    #[OA\Response(
        response: 403,
        description: 'Akses ditolak',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Tidak memiliki akses'),
            ]
        )
    )]
    #[OA\Response(
        response: 404,
        description: 'Post tidak ditemukan',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Data tidak ditemukan'),
            ]
        )
    )]
    public function history(Request $request, string $id): JsonResponse
    {
        try {
            $post = Post::findOrFail($id);

            $user = $request->user();
            $isOwner = $post->user_id === $user->id;
            $isModerator = $user->roles->contains(fn ($r) => in_array($r->name, ['admin', 'moderator']));

            if (! $isOwner && ! $isModerator) {
                return $this->forbidden();
            }

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
