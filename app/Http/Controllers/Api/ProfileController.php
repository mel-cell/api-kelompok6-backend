<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\UpdateProfileRequest;
use App\Http\Resources\UserResource;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

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
                if ($user->avatar_url) {
                    Storage::disk('public')->delete($user->avatar_url);
                }

                $path = $request->file('avatar')->store('avatars', 'public');
                $data['avatar_url'] = $path;
            }

            $user->update($data);

            return $this->resource(new UserResource($user->fresh()->load('roles')), 'Profil berhasil diperbarui');
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }
}
