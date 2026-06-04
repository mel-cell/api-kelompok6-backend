<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\UserResource;
use App\Models\Follow;
use App\Models\User;
use App\Notifications\FollowNotification;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;

class UserController extends Controller
{
    public function show(string $id): JsonResponse
    {
        try {
            $user = Cache::remember("user_{$id}", 3600, function () use ($id) {
                return User::withCount(['followers', 'following', 'posts'])->with('roles')->findOrFail($id);
            });

            return $this->resource(new UserResource($user));
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function followers(string $id): JsonResponse
    {
        try {
            $user = User::findOrFail($id);
            $followers = $user->followers()->with('follower:id,username,avatar_url')->paginate(20);

            return $this->ok($followers);
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function following(string $id): JsonResponse
    {
        try {
            $user = User::findOrFail($id);
            $following = $user->following()->with('following:id,username,avatar_url')->paginate(20);

            return $this->ok($following);
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function toggleFollow(Request $request, string $id): JsonResponse
    {
        try {
            $target = User::findOrFail($id);

            if ($target->id === $request->user()->id) {
                return $this->error('Tidak bisa follow diri sendiri', 422);
            }

            $existing = Follow::where('follower_id', $request->user()->id)
                ->where('following_id', $id)
                ->first();

            if ($existing) {
                $existing->delete();

                Cache::forget("user_{$request->user()->id}");
                Cache::forget("user_{$id}");

                return $this->ok(['is_following' => false], 'Unfollow berhasil');
            }

            Follow::create([
                'follower_id' => $request->user()->id,
                'following_id' => $id,
            ]);

            Cache::forget("user_{$request->user()->id}");
            Cache::forget("user_{$id}");

            $target->notify(new FollowNotification($request->user()));

            return $this->ok(['is_following' => true], 'Follow berhasil');
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }
}
