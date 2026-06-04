<?php

namespace App\Http\Controllers\Api;

use App\Events\VoteCast;
use App\Http\Controllers\Controller;
use App\Models\Comment;
use App\Models\Post;
use App\Models\Vote;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class VoteController extends Controller
{
    public function togglePost(Request $request, string $postId): JsonResponse
    {
        $post = Post::findOrFail($postId);
        $user = $request->user();

        $request->validate(['vote_type' => 'required|in:upvote,downvote']);

        $existing = Vote::where('user_id', $user->id)
            ->where('target_id', $post->id)
            ->where('target_type', 'post')
            ->first();

        if ($existing) {
            if ($existing->vote_type === $request->vote_type) {
                $existing->delete();
                $delta = $request->vote_type === 'upvote' ? -1 : 1;
                $post->vote_score += $delta;
                $post->save();

                VoteCast::dispatch($post->user, $request->vote_type === 'upvote' ? 'upvote_received' : 'downvote_received', -2, $post->id, 'post');

                return response()->json(['message' => 'Vote dihapus', 'vote_score' => $post->fresh()->vote_score]);
            }

            $oldType = $existing->vote_type;
            $existing->update(['vote_type' => $request->vote_type]);
            $post->vote_score += $request->vote_type === 'upvote' ? 2 : -2;
            $post->save();

            VoteCast::dispatch($post->user, $request->vote_type === 'upvote' ? 'upvote_received' : 'downvote_received', $request->vote_type === 'upvote' ? 4 : -4, $post->id, 'post');

            return response()->json(['message' => 'Vote diubah', 'vote_type' => $request->vote_type, 'vote_score' => $post->fresh()->vote_score]);
        }

        Vote::create([
            'user_id' => $user->id,
            'target_id' => $post->id,
            'target_type' => 'post',
            'vote_type' => $request->vote_type,
        ]);

        $delta = $request->vote_type === 'upvote' ? 1 : -1;
        $post->vote_score += $delta;
        $post->save();

        VoteCast::dispatch($post->user, $request->vote_type === 'upvote' ? 'upvote_received' : 'downvote_received', $request->vote_type === 'upvote' ? 2 : -2, $post->id, 'post');

        return response()->json(['message' => 'Vote berhasil', 'vote_type' => $request->vote_type, 'vote_score' => $post->fresh()->vote_score], 201);
    }

    public function toggleComment(Request $request, string $commentId): JsonResponse
    {
        $comment = Comment::findOrFail($commentId);
        $user = $request->user();

        $request->validate(['vote_type' => 'required|in:upvote,downvote']);

        $existing = Vote::where('user_id', $user->id)
            ->where('target_id', $comment->id)
            ->where('target_type', 'comment')
            ->first();

        if ($existing) {
            if ($existing->vote_type === $request->vote_type) {
                $existing->delete();
                $delta = $request->vote_type === 'upvote' ? -1 : 1;
                $comment->vote_score += $delta;
                $comment->save();

                VoteCast::dispatch($comment->user, $request->vote_type === 'upvote' ? 'upvote_received' : 'downvote_received', -2, $comment->id, 'comment');

                return response()->json(['message' => 'Vote dihapus', 'vote_score' => $comment->fresh()->vote_score]);
            }

            $existing->update(['vote_type' => $request->vote_type]);
            $comment->vote_score += $request->vote_type === 'upvote' ? 2 : -2;
            $comment->save();

            VoteCast::dispatch($comment->user, $request->vote_type === 'upvote' ? 'upvote_received' : 'downvote_received', $request->vote_type === 'upvote' ? 4 : -4, $comment->id, 'comment');

            return response()->json(['message' => 'Vote diubah', 'vote_type' => $request->vote_type, 'vote_score' => $comment->fresh()->vote_score]);
        }

        Vote::create([
            'user_id' => $user->id,
            'target_id' => $comment->id,
            'target_type' => 'comment',
            'vote_type' => $request->vote_type,
        ]);

        $delta = $request->vote_type === 'upvote' ? 1 : -1;
        $comment->vote_score += $delta;
        $comment->save();

        VoteCast::dispatch($comment->user, $request->vote_type === 'upvote' ? 'upvote_received' : 'downvote_received', $request->vote_type === 'upvote' ? 2 : -2, $comment->id, 'comment');

        return response()->json(['message' => 'Vote berhasil', 'vote_type' => $request->vote_type, 'vote_score' => $comment->fresh()->vote_score], 201);
    }
}
