<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\CommentResource;
use App\Http\Resources\PostResource;
use App\Http\Resources\UserResource;
use App\Models\Comment;
use App\Models\Post;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use OpenApi\Attributes as OA;

class SearchController extends Controller
{
    #[OA\Get(
        path: '/api/v1/search/posts',
        summary: 'Cari post',
        security: [['bearerAuth' => []]],
        tags: ['Search']
    )]
    #[OA\Parameter(name: 'q', in: 'query', required: true, schema: new OA\Schema(type: 'string', minLength: 2))]
    #[OA\Parameter(name: 'per_page', in: 'query', required: false, schema: new OA\Schema(type: 'integer', default: 15))]
    #[OA\Response(
        response: 200,
        description: 'Hasil pencarian post'
    )]
    #[OA\Response(
        response: 401,
        description: 'Tidak terautentikasi'
    )]
    #[OA\Response(
        response: 422,
        description: 'Validasi gagal (q minimal 2 karakter)'
    )]
    public function posts(Request $request): JsonResponse
    {
        try {
            $request->validate(['q' => 'required|string|min:2']);

            $ids = Post::search($request->q)->get()->pluck('id');
            $posts = Post::with(['user:id,username,avatar_url', 'category:id,name,slug', 'tags:id,name,slug,color'])
                ->whereIn('id', $ids)
                ->orderBy('created_at', 'desc')
                ->paginate(min($request->per_page ?? 15, 50));

            return $this->resource(PostResource::collection($posts));
        } catch (ValidationException $e) {
            throw $e;
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    #[OA\Get(
        path: '/api/v1/search/comments',
        summary: 'Cari komentar',
        security: [['bearerAuth' => []]],
        tags: ['Search']
    )]
    #[OA\Parameter(name: 'q', in: 'query', required: true, schema: new OA\Schema(type: 'string', minLength: 2))]
    #[OA\Parameter(name: 'per_page', in: 'query', required: false, schema: new OA\Schema(type: 'integer', default: 15))]
    #[OA\Response(
        response: 200,
        description: 'Hasil pencarian komentar'
    )]
    #[OA\Response(
        response: 401,
        description: 'Tidak terautentikasi'
    )]
    #[OA\Response(
        response: 422,
        description: 'Validasi gagal (q minimal 2 karakter)'
    )]
    public function comments(Request $request): JsonResponse
    {
        try {
            $request->validate(['q' => 'required|string|min:2']);

            $ids = Comment::search($request->q)->get()->pluck('id');
            $comments = Comment::with('user:id,username,avatar_url')
                ->whereIn('id', $ids)
                ->orderBy('created_at', 'desc')
                ->paginate(min($request->per_page ?? 15, 50));

            return $this->resource(CommentResource::collection($comments));
        } catch (ValidationException $e) {
            throw $e;
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    #[OA\Get(
        path: '/api/v1/search/users',
        summary: 'Cari user',
        security: [['bearerAuth' => []]],
        tags: ['Search']
    )]
    #[OA\Parameter(name: 'q', in: 'query', required: true, schema: new OA\Schema(type: 'string', minLength: 2))]
    #[OA\Parameter(name: 'per_page', in: 'query', required: false, schema: new OA\Schema(type: 'integer', default: 15))]
    #[OA\Response(
        response: 200,
        description: 'Hasil pencarian user'
    )]
    #[OA\Response(
        response: 401,
        description: 'Tidak terautentikasi'
    )]
    #[OA\Response(
        response: 422,
        description: 'Validasi gagal (q minimal 2 karakter)'
    )]
    public function users(Request $request): JsonResponse
    {
        try {
            $request->validate(['q' => 'required|string|min:2']);

            $ids = User::search($request->q)->get()->pluck('id');
            $users = User::whereIn('id', $ids)
                ->orderBy('reputation_points', 'desc')
                ->paginate(min($request->per_page ?? 15, 50));

            return $this->resource(UserResource::collection($users));
        } catch (ValidationException $e) {
            throw $e;
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }
}
