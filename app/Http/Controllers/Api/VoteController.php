<?php

namespace App\Http\Controllers\Api;

use App\Events\VoteCast;
use App\Http\Controllers\Controller;
use App\Models\Comment;
use App\Models\Post;
use App\Models\Vote;
use App\Notifications\VoteNotification;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use OpenApi\Attributes as OA;

class VoteController extends Controller
{
    #[OA\Post(
        path: '/api/v1/posts/{postId}/vote',
        summary: 'Toggle vote (upvote/downvote) pada post',
        security: [['bearerAuth' => []]],
        tags: ['Posts']
    )]
    #[OA\Parameter(name: 'postId', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            required: ['vote_type'],
            properties: [
                new OA\Property(property: 'vote_type', type: 'string', enum: ['upvote', 'downvote']),
            ]
        )
    )]
    #[OA\Response(
        response: 200,
        description: 'Vote dihapus atau diubah',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Vote dihapus'),
                new OA\Property(property: 'data', properties: [
                    new OA\Property(property: 'vote_type', type: 'string', nullable: true),
                    new OA\Property(property: 'vote_score', type: 'integer'),
                ]),
            ]
        )
    )]
    #[OA\Response(
        response: 201,
        description: 'Vote berhasil ditambahkan',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Vote berhasil'),
                new OA\Property(property: 'data', properties: [
                    new OA\Property(property: 'vote_type', type: 'string'),
                    new OA\Property(property: 'vote_score', type: 'integer'),
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

                    if ($post->user_id !== $user->id) {
                        $post->user->notify(new VoteNotification($user, $request->vote_type, $post->id, 'post'));
                    }

                    return $this->ok(['vote_score' => $post->fresh()->vote_score], 'Vote dihapus');
                }

                $existing->update(['vote_type' => $request->vote_type]);
                $post->vote_score += $request->vote_type === 'upvote' ? 2 : -2;
                $post->save();

                VoteCast::dispatch($post->user, $request->vote_type === 'upvote' ? 'upvote_received' : 'downvote_received', $request->vote_type === 'upvote' ? 4 : -4, $post->id, 'post');

                if ($post->user_id !== $user->id) {
                    $post->user->notify(new VoteNotification($user, $request->vote_type, $post->id, 'post'));
                }

                return $this->ok(['vote_type' => $request->vote_type, 'vote_score' => $post->fresh()->vote_score], 'Vote diubah');
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

            if ($post->user_id !== $user->id) {
                $post->user->notify(new VoteNotification($user, $request->vote_type, $post->id, 'post'));
            }

            return $this->created(['vote_type' => $request->vote_type, 'vote_score' => $post->fresh()->vote_score], 'Vote berhasil');
        } catch (ValidationException $e) {
            throw $e;
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    #[OA\Post(
        path: '/api/v1/comments/{commentId}/vote',
        summary: 'Toggle vote (upvote/downvote) pada komentar',
        security: [['bearerAuth' => []]],
        tags: ['Comments']
    )]
    #[OA\Parameter(name: 'commentId', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            required: ['vote_type'],
            properties: [
                new OA\Property(property: 'vote_type', type: 'string', enum: ['upvote', 'downvote']),
            ]
        )
    )]
    #[OA\Response(
        response: 200,
        description: 'Vote dihapus atau diubah',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Vote dihapus'),
                new OA\Property(property: 'data', properties: [
                    new OA\Property(property: 'vote_type', type: 'string', nullable: true),
                    new OA\Property(property: 'vote_score', type: 'integer'),
                ]),
            ]
        )
    )]
    #[OA\Response(
        response: 201,
        description: 'Vote berhasil ditambahkan',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Vote berhasil'),
                new OA\Property(property: 'data', properties: [
                    new OA\Property(property: 'vote_type', type: 'string'),
                    new OA\Property(property: 'vote_score', type: 'integer'),
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

                    if ($comment->user_id !== $user->id) {
                        $comment->user->notify(new VoteNotification($user, $request->vote_type, $comment->id, 'comment'));
                    }

                    return $this->ok(['vote_score' => $comment->fresh()->vote_score], 'Vote dihapus');
                }

                $existing->update(['vote_type' => $request->vote_type]);
                $comment->vote_score += $request->vote_type === 'upvote' ? 2 : -2;
                $comment->save();

                VoteCast::dispatch($comment->user, $request->vote_type === 'upvote' ? 'upvote_received' : 'downvote_received', $request->vote_type === 'upvote' ? 4 : -4, $comment->id, 'comment');

                if ($comment->user_id !== $user->id) {
                    $comment->user->notify(new VoteNotification($user, $request->vote_type, $comment->id, 'comment'));
                }

                return $this->ok(['vote_type' => $request->vote_type, 'vote_score' => $comment->fresh()->vote_score], 'Vote diubah');
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

            if ($comment->user_id !== $user->id) {
                $comment->user->notify(new VoteNotification($user, $request->vote_type, $comment->id, 'comment'));
            }

            return $this->created(['vote_type' => $request->vote_type, 'vote_score' => $comment->fresh()->vote_score], 'Vote berhasil');
        } catch (ValidationException $e) {
            throw $e;
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }
}
