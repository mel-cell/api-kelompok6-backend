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
use OpenApi\Attributes as OA;

class CommentController extends Controller
{
    #[OA\Get(
        path: '/api/v1/posts/{postId}/comments',
        summary: 'Daftar komentar dari sebuah post',
        tags: ['Comments']
    )]
    #[OA\Parameter(name: 'postId', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\Response(
        response: 200,
        description: 'Daftar komentar berhasil diambil',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Berhasil'),
                new OA\Property(property: 'data', type: 'array', items: new OA\Items(ref: '#/components/schemas/Comment')),
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

    #[OA\Post(
        path: '/api/v1/posts/{postId}/comments',
        summary: 'Tambah komentar baru',
        security: [['bearerAuth' => []]],
        tags: ['Comments']
    )]
    #[OA\Parameter(name: 'postId', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            required: ['body'],
            properties: [
                new OA\Property(property: 'body', type: 'string', example: 'Penjelasan yang bagus!'),
                new OA\Property(property: 'parent_id', type: 'string', format: 'uuid', nullable: true),
            ]
        )
    )]
    #[OA\Response(
        response: 201,
        description: 'Komentar berhasil ditambahkan',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Komentar berhasil ditambahkan'),
                new OA\Property(property: 'data', ref: '#/components/schemas/Comment'),
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
        response: 404,
        description: 'Post tidak ditemukan',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Data tidak ditemukan'),
            ]
        )
    )]
    public function store(StoreCommentRequest $request, string $postId): JsonResponse
    {
        try {
            $user = $request->user();

            if ($user->reputation_points < -50) {
                return $this->forbidden('Reputasi kamu terlalu rendah untuk berkomentar');
            }

            if ($user->reputation_points < -20) {
                session()->flash('reputation_warning', true);
            }

            $post = Post::findOrFail($postId);

            $comment = Comment::create([
                'post_id' => $post->id,
                'user_id' => $user->id,
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

    #[OA\Put(
        path: '/api/v1/comments/{id}',
        summary: 'Update komentar (pemilik atau moderator)',
        security: [['bearerAuth' => []]],
        tags: ['Comments']
    )]
    #[OA\Parameter(name: 'id', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            required: ['body'],
            properties: [
                new OA\Property(property: 'body', type: 'string', example: 'Komentar yang diedit...'),
            ]
        )
    )]
    #[OA\Response(
        response: 200,
        description: 'Komentar diperbarui',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Komentar diperbarui'),
                new OA\Property(property: 'data', ref: '#/components/schemas/Comment'),
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
        description: 'Komentar tidak ditemukan',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Data tidak ditemukan'),
            ]
        )
    )]
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

    #[OA\Delete(
        path: '/api/v1/comments/{id}',
        summary: 'Hapus komentar (pemilik atau moderator)',
        security: [['bearerAuth' => []]],
        tags: ['Comments']
    )]
    #[OA\Parameter(name: 'id', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\Response(
        response: 200,
        description: 'Komentar dihapus',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Komentar dihapus'),
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
        description: 'Komentar tidak ditemukan',
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

    #[OA\Get(
        path: '/api/v1/comments/{id}/history',
        summary: 'Riwayat edit komentar (pemilik atau moderator)',
        security: [['bearerAuth' => []]],
        tags: ['Comments']
    )]
    #[OA\Parameter(name: 'id', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\Response(
        response: 200,
        description: 'Riwayat edit komentar',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Berhasil'),
                new OA\Property(property: 'data', type: 'array', items: new OA\Items(
                    properties: [
                        new OA\Property(property: 'id', type: 'string', format: 'uuid'),
                        new OA\Property(property: 'body_before', type: 'string'),
                        new OA\Property(property: 'body_after', type: 'string'),
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
        description: 'Komentar tidak ditemukan',
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
