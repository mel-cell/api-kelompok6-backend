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

class AuthController extends Controller
{
    public function register(RegisterRequest $request): JsonResponse
    {
        try {
            $user = User::create([
                'username' => $request->username,
                'email' => $request->email,
                'password_hash' => Hash::make($request->password),
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

    public function logout(Request $request): JsonResponse
    {
        try {
            $request->user()->currentAccessToken()->delete();

            return $this->ok(null, 'Logout berhasil');
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function me(Request $request): JsonResponse
    {
        try {
            return $this->resource(new UserResource($request->user()->load('roles')));
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }
}
