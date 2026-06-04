<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Comment;
use App\Models\Like;
use App\Models\Post;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class LikeController extends Controller
{
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
