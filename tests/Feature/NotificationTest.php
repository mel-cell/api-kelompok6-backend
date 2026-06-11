<?php

namespace Tests\Feature;

use App\Models\Role;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Notifications\Notification;
use Tests\TestCase;

class NotificationTest extends TestCase
{
    use RefreshDatabase;

    protected User $user;

    protected string $token;

    protected function setUp(): void
    {
        parent::setUp();
        Role::create(['id' => fake()->uuid(), 'name' => 'user', 'permissions' => []]);
        $this->user = User::create([
            'username' => 'budi', 'email' => 'budi@example.com',
            'password_hash' => bcrypt('password'),
        ]);
        $this->token = $this->user->createToken('auth-token')->plainTextToken;
    }

    public function test_index_success(): void
    {
        $this->user->notify(new class extends Notification
        {
            public function via($notifiable): array
            {
                return ['database'];
            }

            public function toArray($notifiable): array
            {
                return ['message' => 'Test'];
            }
        });

        $response = $this->withToken($this->token)->getJson('/api/v1/notifications');

        $response->assertStatus(200)
            ->assertJsonStructure(['success', 'message', 'data', 'meta', 'links']);
    }

    public function test_unread_count(): void
    {
        $this->user->notify(new class extends Notification
        {
            public function via($notifiable): array
            {
                return ['database'];
            }

            public function toArray($notifiable): array
            {
                return ['message' => 'Test'];
            }
        });

        $response = $this->withToken($this->token)->getJson('/api/v1/notifications/unread-count');

        $response->assertStatus(200)
            ->assertJsonPath('data.unread_count', 1);
    }

    public function test_mark_read_success(): void
    {
        $notification = $this->user->notifications()->create([
            'id' => fake()->uuid(),
            'type' => 'App\Notifications\Test',
            'data' => ['message' => 'Test'],
        ]);

        $response = $this->withToken($this->token)->patchJson(
            "/api/v1/notifications/{$notification->id}/read"
        );

        $response->assertStatus(200);
        $this->assertNotNull($notification->fresh()->read_at);
    }

    public function test_mark_all_read(): void
    {
        $this->user->notifications()->create([
            'id' => fake()->uuid(), 'type' => 'Test', 'data' => ['msg' => '1'],
        ]);
        $this->user->notifications()->create([
            'id' => fake()->uuid(), 'type' => 'Test', 'data' => ['msg' => '2'],
        ]);

        $response = $this->withToken($this->token)->patchJson(
            '/api/v1/notifications/read-all'
        );

        $response->assertStatus(200);
        $this->assertEquals(0, $this->user->fresh()->unreadNotifications->count());
    }

    public function test_mark_read_unauthenticated(): void
    {
        $response = $this->patchJson(
            '/api/v1/notifications/'.fake()->uuid().'/read'
        );
        $response->assertStatus(401);
    }
}
