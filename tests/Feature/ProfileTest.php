<?php

namespace Tests\Feature;

use App\Models\Role;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Storage;
use Tests\TestCase;

class ProfileTest extends TestCase
{
    use RefreshDatabase;

    protected User $user;

    protected string $token;

    protected function setUp(): void
    {
        parent::setUp();
        Storage::fake('public');
        Role::create(['id' => fake()->uuid(), 'name' => 'user', 'permissions' => ['edit_own_profile']]);
        $this->user = User::create([
            'username' => 'budi',
            'email' => 'budi@example.com',
            'password_hash' => bcrypt('password'),
            'bio' => 'Hello',
        ]);
        $this->token = $this->user->createToken('auth-token')->plainTextToken;
    }

    public function test_show_profile_success(): void
    {
        $response = $this->withToken($this->token)->getJson('/api/v1/profile');

        $response->assertStatus(200)
            ->assertJsonStructure(['success', 'message', 'data' => ['id', 'username', 'bio']])
            ->assertJsonPath('data.username', 'budi');
    }

    public function test_show_profile_unauthenticated(): void
    {
        $response = $this->getJson('/api/v1/profile');
        $response->assertStatus(401);
    }

    public function test_update_profile_success(): void
    {
        $response = $this->withToken($this->token)->putJson('/api/v1/profile', [
            'username' => 'budiupdate',
            'bio' => 'Bio baru',
        ]);

        $response->assertStatus(200)
            ->assertJsonPath('data.username', 'budiupdate')
            ->assertJsonPath('data.bio', 'Bio baru');
    }

    public function test_update_profile_with_avatar(): void
    {
        $response = $this->withToken($this->token)->putJson('/api/v1/profile', [
            'username' => 'budi',
            'bio' => 'Bio diperbarui',
        ]);

        $response->assertStatus(200)
            ->assertJsonPath('data.bio', 'Bio diperbarui');
    }

    public function test_destroy_avatar_success(): void
    {
        $this->user->update(['avatar_url' => 'avatars/test.jpg']);
        Storage::disk('public')->put('avatars/test.jpg', 'fake');

        $response = $this->withToken($this->token)->deleteJson('/api/v1/profile/avatar');

        $response->assertStatus(200);
        $this->assertNull($this->user->fresh()->avatar_url);
    }

    public function test_destroy_avatar_no_avatar(): void
    {
        $response = $this->withToken($this->token)->deleteJson('/api/v1/profile/avatar');
        $response->assertStatus(404);
    }

    public function test_update_email_success(): void
    {
        $response = $this->withToken($this->token)->putJson('/api/v1/profile', [
            'email' => 'baru@example.com',
        ]);

        $response->assertStatus(200);
        $this->assertEquals('baru@example.com', $this->user->fresh()->email);
    }

    public function test_update_password_success(): void
    {
        $response = $this->withToken($this->token)->putJson('/api/v1/profile/password', [
            'current_password' => 'password',
            'password' => 'passwordbaru',
            'password_confirmation' => 'passwordbaru',
        ]);

        $response->assertStatus(200)
            ->assertJsonPath('message', 'Password berhasil diubah');
    }

    public function test_update_password_wrong_current(): void
    {
        $response = $this->withToken($this->token)->putJson('/api/v1/profile/password', [
            'current_password' => 'salah',
            'password' => 'passwordbaru',
            'password_confirmation' => 'passwordbaru',
        ]);

        $response->assertStatus(422);
    }

    public function test_update_password_confirmation_mismatch(): void
    {
        $response = $this->withToken($this->token)->putJson('/api/v1/profile/password', [
            'current_password' => 'password',
            'password' => 'passwordbaru',
            'password_confirmation' => 'tidakcocok',
        ]);

        $response->assertStatus(422);
    }

    public function test_profile_contains_email_for_owner(): void
    {
        $response = $this->withToken($this->token)->getJson('/api/v1/profile');

        $response->assertStatus(200)
            ->assertJsonPath('data.email', 'budi@example.com');
    }

    public function test_profile_hides_email_for_others(): void
    {
        $other = User::create([
            'username' => 'oranglain',
            'email' => 'other@example.com',
            'password_hash' => bcrypt('password'),
        ]);
        $otherToken = $other->createToken('auth-token')->plainTextToken;

        $response = $this->withToken($otherToken)->getJson('/api/v1/users/'.$this->user->id);

        $response->assertStatus(200);
        $this->assertArrayNotHasKey('email', $response['data']);
    }
}
