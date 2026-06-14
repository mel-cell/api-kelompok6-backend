<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\UserResource;
use App\Models\Follow;
use App\Models\PointsLog;
use App\Models\ShadowBan;
use App\Models\User;
use App\Notifications\FollowNotification;
use App\Notifications\UserStatusNotification;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use OpenApi\Attributes as OA;

class UserController extends Controller
{
    #[OA\Get(
        path: '/api/v1/users/{id}',
        summary: 'Detail profil user',
        security: [['bearerAuth' => []]],
        tags: ['Users']
    )]
    #[OA\Parameter(name: 'id', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\Response(
        response: 200,
        description: 'Detail user berhasil diambil',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Berhasil'),
                new OA\Property(property: 'data', ref: '#/components/schemas/User'),
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
        description: 'User tidak ditemukan',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Data tidak ditemukan'),
            ]
        )
    )]
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

    #[OA\Get(
        path: '/api/v1/users/{id}/followers',
        summary: 'Daftar followers user',
        security: [['bearerAuth' => []]],
        tags: ['Users']
    )]
    #[OA\Parameter(name: 'id', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\Response(
        response: 200,
        description: 'Daftar followers berhasil diambil',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Berhasil'),
                new OA\Property(property: 'data', type: 'array', items: new OA\Items(
                    properties: [
                        new OA\Property(property: 'id', type: 'string', format: 'uuid'),
                        new OA\Property(property: 'follower', ref: '#/components/schemas/User'),
                        new OA\Property(property: 'created_at', type: 'string', format: 'date-time'),
                    ]
                )),
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
        description: 'User tidak ditemukan',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Data tidak ditemukan'),
            ]
        )
    )]
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

    #[OA\Get(
        path: '/api/v1/users/{id}/following',
        summary: 'Daftar following user',
        security: [['bearerAuth' => []]],
        tags: ['Users']
    )]
    #[OA\Parameter(name: 'id', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\Response(
        response: 200,
        description: 'Daftar following berhasil diambil',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Berhasil'),
                new OA\Property(property: 'data', type: 'array', items: new OA\Items(
                    properties: [
                        new OA\Property(property: 'id', type: 'string', format: 'uuid'),
                        new OA\Property(property: 'following', ref: '#/components/schemas/User'),
                        new OA\Property(property: 'created_at', type: 'string', format: 'date-time'),
                    ]
                )),
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
        description: 'User tidak ditemukan',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Data tidak ditemukan'),
            ]
        )
    )]
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

    #[OA\Post(
        path: '/api/v1/users/{id}/follow',
        summary: 'Toggle follow/unfollow user',
        security: [['bearerAuth' => []]],
        tags: ['Users']
    )]
    #[OA\Parameter(name: 'id', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\Response(
        response: 200,
        description: 'Follow atau unfollow berhasil',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Follow berhasil'),
                new OA\Property(property: 'data', properties: [
                    new OA\Property(property: 'is_following', type: 'boolean', example: true),
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
        description: 'User tidak ditemukan',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Data tidak ditemukan'),
            ]
        )
    )]
    #[OA\Response(
        response: 422,
        description: 'Tidak bisa follow diri sendiri',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Tidak bisa follow diri sendiri'),
            ]
        )
    )]
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

    public function byUsername(string $username): JsonResponse
    {
        try {
            $user = User::withCount(['followers', 'following', 'posts'])->with('roles')
                ->where('username', $username)
                ->firstOrFail();

            return $this->resource(new UserResource($user));
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function index(Request $request): JsonResponse
    {
        try {
            $query = User::with('roles')->withCount(['followers', 'following', 'posts']);

            if ($request->filled('search')) {
                $search = $request->search;
                $query->where(function ($q) use ($search) {
                    $q->where('username', 'like', "%{$search}%")
                        ->orWhere('email', 'like', "%{$search}%");
                });
            }

            if ($request->filled('role')) {
                $query->whereHas('roles', fn ($q) => $q->where('name', $request->role));
            }

            if ($request->has('is_banned')) {
                $query->where('is_banned', $request->boolean('is_banned'));
            }

            $users = $query->orderBy('created_at', 'desc')->paginate($request->per_page ?? 20);

            return $this->resource(UserResource::collection($users));
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function toggleBan(Request $request, string $id): JsonResponse
    {
        try {
            $user = User::findOrFail($id);

            if ($user->id === $request->user()->id) {
                return $this->error('Tidak bisa ban diri sendiri', 422);
            }

            $user->update(['is_banned' => ! $user->is_banned]);
            Cache::forget("user_{$id}");

            $action = $user->is_banned ? 'banned' : 'unbanned';
            $user->notify(new UserStatusNotification(
                action: $action,
                reason: null,
                actor: $request->user(),
            ));

            $status = $user->is_banned ? 'di-ban' : 'di-unban';

            return $this->ok(['is_banned' => $user->is_banned], "User berhasil {$status}");
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function shadowBan(Request $request, string $id): JsonResponse
    {
        try {
            $validated = $request->validate([
                'reason' => 'required|string|max:500',
                'reputation_penalty' => 'required|integer|min:0|max:1000',
                'restriction_type' => 'required|in:post,comment,both',
                'restriction_duration' => 'required|integer|min:1|max:8760',
            ]);

            $user = User::findOrFail($id);

            if ($user->id === $request->user()->id) {
                return $this->error('Tidak bisa shadow ban diri sendiri', 422);
            }

            $expiresAt = now()->addHours((int) $validated['restriction_duration']);

            ShadowBan::create([
                'user_id' => $user->id,
                'reason' => $validated['reason'],
                'restriction_type' => $validated['restriction_type'],
                'restriction_duration' => (int) $validated['restriction_duration'],
                'expires_at' => $expiresAt,
                'created_by' => $request->user()->id,
            ]);

            if ($validated['reputation_penalty'] > 0) {
                $user->decrement('reputation_points', (int) $validated['reputation_penalty']);
                PointsLog::create([
                    'user_id' => $user->id,
                    'points' => -((int) $validated['reputation_penalty']),
                    'action_type' => 'shadow_ban',
                    'description' => 'Shadow ban: '.$validated['reason'],
                ]);
            }

            $user->notify(new UserStatusNotification(
                action: 'shadow_banned',
                reason: $validated['reason'],
                actor: $request->user(),
            ));

            Cache::forget("user_{$id}");

            return $this->ok(null, 'Shadow ban berhasil diterapkan');
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function warn(Request $request, string $id): JsonResponse
    {
        try {
            $validated = $request->validate([
                'reason' => 'required|string|max:1000',
            ]);

            $user = User::findOrFail($id);

            if ($user->id === $request->user()->id) {
                return $this->error('Tidak bisa memperingati diri sendiri', 422);
            }

            $user->notify(new UserStatusNotification(
                action: 'warned',
                reason: $validated['reason'],
                actor: $request->user(),
            ));

            return $this->ok(null, 'Peringatan berhasil dikirim');
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }
}
