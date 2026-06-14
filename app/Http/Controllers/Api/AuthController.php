<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\LoginRequest;
use App\Http\Requests\RegisterRequest;
use App\Http\Resources\UserResource;
use App\Models\Role;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use OpenApi\Attributes as OA;

class AuthController extends Controller
{
    #[OA\Post(
        path: '/api/v1/register',
        summary: 'Pendaftaran User Baru',
        tags: ['Authentication']
    )]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            required: ['username', 'email', 'password', 'password_confirmation'],
            properties: [
                new OA\Property(property: 'username', type: 'string', example: 'budi'),
                new OA\Property(property: 'email', type: 'string', format: 'email', example: 'budi@example.com'),
                new OA\Property(property: 'password', type: 'string', format: 'password', example: 'Password123'),
                new OA\Property(property: 'password_confirmation', type: 'string', format: 'password', example: 'Password123'),
            ]
        )
    )]
    #[OA\Response(
        response: 201,
        description: 'Pendaftaran Berhasil',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Register berhasil'),
                new OA\Property(property: 'data', properties: [
                    new OA\Property(property: 'user', ref: '#/components/schemas/User'),
                    new OA\Property(property: 'token', type: 'string'),
                ]),
            ]
        )
    )]
    #[OA\Response(
        response: 422,
        description: 'Validasi Gagal',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Validasi gagal'),
                new OA\Property(property: 'errors', type: 'object'),
            ]
        )
    )]
    public function register(RegisterRequest $request): JsonResponse
    {
        try {
            $user = User::create([
                'username' => $request->username,
                'email' => $request->email,
                'password_hash' => Hash::make($request->password),
                'reputation_points' => 10,
            ]);

            $userRole = Role::where('name', 'user')->first();
            if ($userRole) {
                $user->roles()->attach($userRole->id, ['assigned_at' => now()]);
            }

            $token = $user->createToken('auth-token')->plainTextToken;

            return $this->created([
                'user' => $user->load('roles'),
                'token' => $token,
            ], 'Register berhasil');
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    #[OA\Post(
        path: '/api/v1/login',
        summary: 'User Login',
        tags: ['Authentication']
    )]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            required: ['email', 'password'],
            properties: [
                new OA\Property(property: 'email', type: 'string', format: 'email', example: 'budi@example.com'),
                new OA\Property(property: 'password', type: 'string', format: 'password', example: 'Password123'),
            ]
        )
    )]
    #[OA\Response(
        response: 200,
        description: 'Login Berhasil',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Login berhasil'),
                new OA\Property(property: 'data', properties: [
                    new OA\Property(property: 'user', ref: '#/components/schemas/User'),
                    new OA\Property(property: 'token', type: 'string'),
                ]),
            ]
        )
    )]
    #[OA\Response(
        response: 401,
        description: 'Email atau password salah',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Email atau password salah'),
            ]
        )
    )]
    public function login(LoginRequest $request): JsonResponse
    {
        try {
            $user = User::where('email', $request->email)->first();

            if (! $user || ! Hash::check($request->password, $user->password_hash)) {
                return $this->unauthorized('Email atau password salah');
            }

            if ($user->is_banned) {
                return $this->forbidden('Akun kamu telah dibanned');
            }

            $token = $user->createToken('auth-token')->plainTextToken;

            return $this->ok([
                'user' => $user->load('roles'),
                'token' => $token,
            ], 'Login berhasil');
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    #[OA\Post(
        path: '/api/v1/logout',
        summary: 'Logout User',
        security: [['bearerAuth' => []]],
        tags: ['Authentication']
    )]
    #[OA\Response(
        response: 200,
        description: 'Logout berhasil',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Logout berhasil'),
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
    public function logout(Request $request): JsonResponse
    {
        try {
            $request->user()->currentAccessToken()->delete();

            return $this->ok(null, 'Logout berhasil');
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    #[OA\Get(
        path: '/api/v1/user',
        summary: 'Profil User Saat Ini',
        security: [['bearerAuth' => []]],
        tags: ['Authentication']
    )]
    #[OA\Response(
        response: 200,
        description: 'Data profil user',
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
    public function me(Request $request): JsonResponse
    {
        try {
            return $this->resource(new UserResource($request->user()->loadCount(['followers', 'following', 'posts'])->load('roles')));
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }
}
