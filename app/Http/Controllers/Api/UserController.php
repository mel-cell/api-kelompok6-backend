<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Follow;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class UserController extends Controller
{
    public function show(string $id): JsonResponse
    {
        $user = User::withCount(['followers', 'following', 'posts'])->with('roles')->findOrFail($id);

        return response()->json($user);
    }

    public function followers(string $id): JsonResponse
    {
        $user = User::findOrFail($id);
        $followers = $user->followers()->with('follower:id,username,avatar_url')->paginate(20);

        return response()->json($followers);
    }

    public function following(string $id): JsonResponse
    {
        $user = User::findOrFail($id);
        $following = $user->following()->with('following:id,username,avatar_url')->paginate(20);

        return response()->json($following);
    }

    public function toggleFollow(Request $request, string $id): JsonResponse
    {
        $target = User::findOrFail($id);

        if ($target->id === $request->user()->id) {
            return response()->json(['message' => 'Tidak bisa follow diri sendiri'], 422);
        }

        $existing = Follow::where('follower_id', $request->user()->id)
            ->where('following_id', $id)
            ->first();

        if ($existing) {
            $existing->delete();

            return response()->json(['message' => 'Unfollow berhasil', 'is_following' => false]);
        }

        Follow::create([
            'follower_id' => $request->user()->id,
            'following_id' => $id,
        ]);

        return response()->json(['message' => 'Follow berhasil', 'is_following' => true]);
    }
}
