<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\UpdatePasswordRequest;
use App\Http\Requests\UpdateProfileRequest;
use App\Http\Resources\UserResource;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use OpenApi\Attributes as OA;

class ProfileController extends Controller
{
    #[OA\Get(
        path: '/api/v1/profile',
        summary: 'Lihat profil sendiri',
        security: [['bearerAuth' => []]],
        tags: ['Profile']
    )]
    #[OA\Response(
        response: 200,
        description: 'Data profil',
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
    public function show(Request $request): JsonResponse
    {
        try {
            return $this->resource(new UserResource($request->user()->load('roles')));
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    #[OA\Put(
        path: '/api/v1/profile',
        summary: 'Update profil sendiri',
        security: [['bearerAuth' => []]],
        tags: ['Profile']
    )]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'username', type: 'string', example: 'budi'),
                new OA\Property(property: 'email', type: 'string', example: 'budi@example.com'),
                new OA\Property(property: 'bio', type: 'string', example: 'Seorang developer'),
                new OA\Property(property: 'avatar', type: 'string', format: 'binary', description: 'File gambar avatar'),
            ]
        )
    )]
    #[OA\Response(
        response: 200,
        description: 'Profil berhasil diperbarui',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Profil berhasil diperbarui'),
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
        response: 422,
        description: 'Validasi gagal',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Validasi gagal'),
                new OA\Property(property: 'errors', type: 'object'),
            ]
        )
    )]
    public function update(UpdateProfileRequest $request): JsonResponse
    {
        try {
            $user = $request->user();
            $data = $request->only(['username', 'email', 'bio']);

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

    #[OA\Delete(
        path: '/api/v1/profile/avatar',
        summary: 'Hapus avatar sendiri',
        security: [['bearerAuth' => []]],
        tags: ['Profile']
    )]
    #[OA\Response(
        response: 200,
        description: 'Avatar berhasil dihapus',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Avatar berhasil dihapus'),
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
        description: 'Tidak ada avatar untuk dihapus',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Tidak ada avatar untuk dihapus'),
            ]
        )
    )]
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

    #[OA\Put(
        path: '/api/v1/profile/password',
        summary: 'Ubah password sendiri',
        security: [['bearerAuth' => []]],
        tags: ['Profile']
    )]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'current_password', type: 'string', example: 'password-lama'),
                new OA\Property(property: 'password', type: 'string', example: 'password-baru'),
                new OA\Property(property: 'password_confirmation', type: 'string', example: 'password-baru'),
            ]
        )
    )]
    #[OA\Response(
        response: 200,
        description: 'Password berhasil diubah',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Password berhasil diubah'),
            ]
        )
    )]
    #[OA\Response(response: 401, description: 'Tidak terautentikasi')]
    #[OA\Response(response: 422, description: 'Validasi gagal')]
    public function updatePassword(UpdatePasswordRequest $request): JsonResponse
    {
        try {
            $request->user()->update([
                'password_hash' => Hash::make($request->password),
            ]);

            return $this->ok(null, 'Password berhasil diubah');
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    #[OA\Delete(
        path: '/api/v1/profile',
        summary: 'Hapus akun sendiri',
        security: [['bearerAuth' => []]],
        tags: ['Profile']
    )]
    #[OA\Response(
        response: 200,
        description: 'Akun berhasil dihapus',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Akun berhasil dihapus'),
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
    public function destroy(Request $request): JsonResponse
    {
        try {
            $user = $request->user();

            $this->deleteOldAvatar($user);

            $user->tokens()->delete();
            $user->update([
                'is_banned' => true,
                'username' => 'deleted_'.$user->id,
                'email' => 'deleted_'.$user->id.'@deleted.com',
                'avatar_url' => null,
                'bio' => null,
            ]);

            return $this->ok(null, 'Akun berhasil dihapus');
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }
}
