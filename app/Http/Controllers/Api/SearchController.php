<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Comment;
use App\Models\Post;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SearchController extends Controller
{
    public function posts(Request $request): JsonResponse
    {
        $request->validate(['q' => 'required|string|min:2']);

        $ids = Post::search($request->q)->get()->pluck('id');
        $posts = Post::with(['user:id,username,avatar_url', 'category:id,name,slug', 'tags:id,name,slug,color'])
            ->whereIn('id', $ids)
            ->orderBy('created_at', 'desc')
            ->paginate($request->per_page ?? 15);

        return response()->json($posts);
    }

    public function comments(Request $request): JsonResponse
    {
        $request->validate(['q' => 'required|string|min:2']);

        $ids = Comment::search($request->q)->get()->pluck('id');
        $comments = Comment::with('user:id,username,avatar_url')
            ->whereIn('id', $ids)
            ->orderBy('created_at', 'desc')
            ->paginate($request->per_page ?? 15);

        return response()->json($comments);
    }

    public function users(Request $request): JsonResponse
    {
        $request->validate(['q' => 'required|string|min:2']);

        $ids = User::search($request->q)->get()->pluck('id');
        $users = User::whereIn('id', $ids)
            ->orderBy('reputation_points', 'desc')
            ->paginate($request->per_page ?? 15);

        return response()->json($users);
    }
}
