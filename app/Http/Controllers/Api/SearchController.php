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

class SearchController extends Controller
{
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
