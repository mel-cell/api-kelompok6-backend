<?php

namespace Tests\Feature;

use App\Models\Follow;
use App\Models\Role;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class UserTest extends TestCase
{
    use RefreshDatabase;

    protected User $user;

    protected User $target;

    protected string $token;

    protected function setUp(): void
    {
        parent::setUp();
        Role::create(['id' => fake()->uuid(), 'name' => 'user', 'permissions' => []]);
        $this->user = User::create([
            'username' => 'budi', 'email' => 'budi@example.com',
            'password_hash' => bcrypt('password'),
        ]);
        $this->target = User::create([
            'username' => 'target', 'email' => 'target@example.com',
            'password_hash' => bcrypt('password'),
        ]);
        $this->token = $this->user->createToken('auth-token')->plainTextToken;
    }

    public function test_show_success(): void
    {
        $response = $this->withToken($this->token)->getJson(
            "/api/v1/users/{$this->target->id}"
        );

        $response->assertStatus(200)
            ->assertJsonPath('data.username', 'target');
    }

    public function test_show_not_found(): void
    {
        $response = $this->withToken($this->token)->getJson(
            '/api/v1/users/'.fake()->uuid()
        );
        $response->assertStatus(404);
    }

    public function test_toggle_follow(): void
    {
        $response = $this->withToken($this->token)->postJson(
            "/api/v1/users/{$this->target->id}/follow"
        );

        $response->assertStatus(200)
            ->assertJsonPath('data.is_following', true);
    }

    public function test_toggle_unfollow(): void
    {
        Follow::create([
            'follower_id' => $this->user->id,
            'following_id' => $this->target->id,
        ]);

        $response = $this->withToken($this->token)->postJson(
            "/api/v1/users/{$this->target->id}/follow"
        );

        $response->assertStatus(200)
            ->assertJsonPath('data.is_following', false);
    }

    public function test_cannot_follow_self(): void
    {
        $response = $this->withToken($this->token)->postJson(
            "/api/v1/users/{$this->user->id}/follow"
        );

        $response->assertStatus(422);
    }

    public function test_followers_list(): void
    {
        Follow::create([
            'follower_id' => $this->target->id,
            'following_id' => $this->user->id,
        ]);

        $response = $this->withToken($this->token)->getJson(
            "/api/v1/users/{$this->user->id}/followers"
        );

        $response->assertStatus(200);
    }

    public function test_following_list(): void
    {
        Follow::create([
            'follower_id' => $this->user->id,
            'following_id' => $this->target->id,
        ]);

        $response = $this->withToken($this->token)->getJson(
            "/api/v1/users/{$this->user->id}/following"
        );

        $response->assertStatus(200);
    }
}
