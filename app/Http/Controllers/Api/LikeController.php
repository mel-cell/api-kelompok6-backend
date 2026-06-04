<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Comment;
use App\Models\Like;
use App\Models\Post;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use OpenApi\Attributes as OA;

class LikeController extends Controller
{
    #[OA\Post(
        path: '/api/v1/posts/{postId}/like',
        summary: 'Toggle like pada post',
        security: [['bearerAuth' => []]],
        tags: ['Posts']
    )]
    #[OA\Parameter(name: 'postId', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\Response(
        response: 200,
        description: 'Like dihapus / status like berubah',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Like dihapus'),
                new OA\Property(property: 'data', properties: [
                    new OA\Property(property: 'liked', type: 'boolean', example: false),
                ]),
            ]
        )
    )]
    #[OA\Response(
        response: 201,
        description: 'Like berhasil ditambahkan',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Like berhasil'),
                new OA\Property(property: 'data', properties: [
                    new OA\Property(property: 'liked', type: 'boolean', example: true),
                ]),
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
    public function togglePost(Request $request, string $postId): JsonResponse
    {
        try {
            $post = Post::findOrFail($postId);
            $user = $request->user();

            $existing = Like::where('user_id', $user->id)
                ->where('target_id', $post->id)
                ->where('target_type', 'post')
                ->first();

            if ($existing) {
                $existing->delete();

                return $this->ok(['liked' => false], 'Like dihapus');
            }

            Like::create([
                'user_id' => $user->id,
                'target_id' => $post->id,
                'target_type' => 'post',
            ]);

            return $this->created(['liked' => true], 'Like berhasil');
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    #[OA\Post(
        path: '/api/v1/comments/{commentId}/like',
        summary: 'Toggle like pada komentar',
        security: [['bearerAuth' => []]],
        tags: ['Comments']
    )]
    #[OA\Parameter(name: 'commentId', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\Response(
        response: 200,
        description: 'Like dihapus / status like berubah',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Like dihapus'),
                new OA\Property(property: 'data', properties: [
                    new OA\Property(property: 'liked', type: 'boolean', example: false),
                ]),
            ]
        )
    )]
    #[OA\Response(
        response: 201,
        description: 'Like berhasil ditambahkan',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Like berhasil'),
                new OA\Property(property: 'data', properties: [
                    new OA\Property(property: 'liked', type: 'boolean', example: true),
                ]),
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
        description: 'Komentar tidak ditemukan',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Data tidak ditemukan'),
            ]
        )
    )]
    public function toggleComment(Request $request, string $commentId): JsonResponse
    {
        try {
            $comment = Comment::findOrFail($commentId);
            $user = $request->user();

            $existing = Like::where('user_id', $user->id)
                ->where('target_id', $comment->id)
                ->where('target_type', 'comment')
                ->first();

            if ($existing) {
                $existing->delete();

                return $this->ok(['liked' => false], 'Like dihapus');
            }

            Like::create([
                'user_id' => $user->id,
                'target_id' => $comment->id,
                'target_type' => 'comment',
            ]);

            return $this->created(['liked' => true], 'Like berhasil');
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }
}
