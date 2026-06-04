<?php

namespace App\Http\Controllers\Api;

use App\Events\CommentCreated;
use App\Http\Controllers\Controller;
use App\Http\Requests\StoreCommentRequest;
use App\Http\Requests\UpdateCommentRequest;
use App\Models\Comment;
use App\Models\CommentEditHistory;
use App\Models\Post;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CommentController extends Controller
{
    public function index(string $postId): JsonResponse
    {
        $post = Post::findOrFail($postId);

        $comments = $post->comments()
            ->whereNull('parent_id')
            ->with(['user:id,username,avatar_url', 'replies' => function ($q) {
                $q->with('user:id,username,avatar_url')->oldest();
            }])
            ->withCount('replies')
            ->oldest()
            ->get();

        return response()->json($comments);
    }

    public function store(StoreCommentRequest $request, string $postId): JsonResponse
    {
        $post = Post::findOrFail($postId);

        $comment = Comment::create([
            'post_id' => $post->id,
            'user_id' => $request->user()->id,
            'parent_id' => $request->parent_id,
            'body' => $request->body,
        ]);

        $comment->load('user:id,username,avatar_url');

        CommentCreated::dispatch($comment);

        return response()->json([
            'message' => 'Komentar berhasil ditambahkan',
            'comment' => $comment,
        ], 201);
    }

    public function update(UpdateCommentRequest $request, string $id): JsonResponse
    {
        $comment = Comment::findOrFail($id);

        $user = $request->user();
        $isOwner = $comment->user_id === $user->id;
        $isModerator = $user->roles->contains(fn ($r) => in_array($r->name, ['admin', 'moderator']));

        if (! $isOwner && ! $isModerator) {
            return response()->json(['message' => 'Forbidden'], 403);
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

        return response()->json([
            'message' => 'Komentar diperbarui',
            'comment' => $comment->fresh()->load('user:id,username,avatar_url'),
        ]);
    }

    public function destroy(Request $request, string $id): JsonResponse
    {
        $comment = Comment::findOrFail($id);

        $user = $request->user();
        $isOwner = $comment->user_id === $user->id;
        $isModerator = $user->roles->contains(fn ($r) => in_array($r->name, ['admin', 'moderator']));

        if (! $isOwner && ! $isModerator) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $comment->delete();

        return response()->json(['message' => 'Komentar dihapus']);
    }

    public function history(string $id): JsonResponse
    {
        $comment = Comment::findOrFail($id);

        $histories = $comment->editHistories()
            ->with('editor:id,username')
            ->orderBy('edited_at', 'desc')
            ->get();

        return response()->json($histories);
    }
}
