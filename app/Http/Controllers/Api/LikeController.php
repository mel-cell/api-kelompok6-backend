<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Comment;
use App\Models\Like;
use App\Models\Post;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class LikeController extends Controller
{
    public function togglePost(Request $request, string $postId): JsonResponse
    {
        $post = Post::findOrFail($postId);
        $user = $request->user();

        $existing = Like::where('user_id', $user->id)
            ->where('target_id', $post->id)
            ->where('target_type', 'post')
            ->first();

        if ($existing) {
            $existing->delete();

            return response()->json(['message' => 'Like dihapus', 'liked' => false]);
        }

        Like::create([
            'user_id' => $user->id,
            'target_id' => $post->id,
            'target_type' => 'post',
        ]);

        return response()->json(['message' => 'Like berhasil', 'liked' => true], 201);
    }

    public function toggleComment(Request $request, string $commentId): JsonResponse
    {
        $comment = Comment::findOrFail($commentId);
        $user = $request->user();

        $existing = Like::where('user_id', $user->id)
            ->where('target_id', $comment->id)
            ->where('target_type', 'comment')
            ->first();

        if ($existing) {
            $existing->delete();

            return response()->json(['message' => 'Like dihapus', 'liked' => false]);
        }

        Like::create([
            'user_id' => $user->id,
            'target_id' => $comment->id,
            'target_type' => 'comment',
        ]);

        return response()->json(['message' => 'Like berhasil', 'liked' => true], 201);
    }
}
