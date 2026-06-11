<?php

namespace Tests\Feature;

use App\Models\Role;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AuthTest extends TestCase
{
    use RefreshDatabase;

    protected string $password = 'Password123!';

    protected function setUp(): void
    {
        parent::setUp();
        Role::create(['id' => fake()->uuid(), 'name' => 'user', 'permissions' => ['create_posts']]);
    }

    public function test_register_success(): void
    {
        $response = $this->postJson('/api/v1/register', [
            'username' => 'budi',
            'email' => 'budi@example.com',
            'password' => $this->password,
            'password_confirmation' => $this->password,
        ]);

        $response->assertStatus(201)
            ->assertJsonStructure(['success', 'message', 'data' => ['user', 'token']]);
    }

    public function test_register_validation_error(): void
    {
        $response = $this->postJson('/api/v1/register', [
            'username' => '',
            'email' => 'not-email',
            'password' => 'short',
            'password_confirmation' => 'not-matching',
        ]);

        $response->assertStatus(422);
    }

    public function test_login_success(): void
    {
        User::create([
            'username' => 'budi',
            'email' => 'budi@example.com',
            'password_hash' => bcrypt($this->password),
        ]);

        $response = $this->postJson('/api/v1/login', [
            'email' => 'budi@example.com',
            'password' => $this->password,
        ]);

        $response->assertStatus(200)
            ->assertJsonStructure(['success', 'message', 'data' => ['user', 'token']]);
    }

    public function test_login_invalid_credentials(): void
    {
        $response = $this->postJson('/api/v1/login', [
            'email' => 'nonexistent@example.com',
            'password' => 'wrongpassword',
        ]);

        $response->assertStatus(401);
    }

    public function test_logout_success(): void
    {
        $user = User::create([
            'username' => 'budi',
            'email' => 'budi@example.com',
            'password_hash' => bcrypt($this->password),
        ]);
        $token = $user->createToken('auth-token')->plainTextToken;

        $response = $this->withToken($token)->postJson('/api/v1/logout');

        $response->assertStatus(200)
            ->assertJson(['success' => true, 'message' => 'Logout berhasil']);
    }

    public function test_logout_unauthenticated(): void
    {
        $response = $this->postJson('/api/v1/logout');

        $response->assertStatus(401);
    }

    public function test_me_success(): void
    {
        $user = User::create([
            'username' => 'budi',
            'email' => 'budi@example.com',
            'password_hash' => bcrypt($this->password),
        ]);
        $token = $user->createToken('auth-token')->plainTextToken;

        $response = $this->withToken($token)->getJson('/api/v1/user');

        $response->assertStatus(200)
            ->assertJsonStructure(['success', 'message', 'data' => ['id', 'username', 'avatar_url', 'bio', 'reputation_points', 'created_at', 'roles']]);
    }

    public function test_me_unauthenticated(): void
    {
        $response = $this->getJson('/api/v1/user');

        $response->assertStatus(401);
    }
}
