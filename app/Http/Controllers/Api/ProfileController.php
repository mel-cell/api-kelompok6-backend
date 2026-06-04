<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\UpdateProfileRequest;
use App\Http\Resources\UserResource;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class ProfileController extends Controller
{
    public function show(Request $request): JsonResponse
    {
        try {
            return $this->resource(new UserResource($request->user()->load('roles')));
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function update(UpdateProfileRequest $request): JsonResponse
    {
        try {
            $user = $request->user();
            $data = $request->only(['username', 'bio']);

            if ($request->hasFile('avatar')) {
                $this->deleteOldAvatar($user);

                $extension = $request->file('avatar')->extension();
                $filename = Str::uuid().'.'.$extension;
                $path = $request->file('avatar')->storeAs('avatars', $filename, 'public');

                if ($path === false) {
                    return $this->error('Gagal menyimpan avatar', 500);
                }

                $data['avatar_url'] = $path;
            }

            $user->update($data);

            return $this->resource(new UserResource($user->fresh()->load('roles')), 'Profil berhasil diperbarui');
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function destroyAvatar(Request $request): JsonResponse
    {
        try {
            $user = $request->user();

            if (! $user->avatar_url) {
                return $this->error('Tidak ada avatar untuk dihapus', 404);
            }

            $this->deleteOldAvatar($user);
            $user->update(['avatar_url' => null]);

            return $this->ok(new UserResource($user->fresh()->load('roles')), 'Avatar berhasil dihapus');
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    private function deleteOldAvatar($user): void
    {
        if ($user->avatar_url) {
            Storage::disk('public')->delete($user->avatar_url);
        }
    }
}
