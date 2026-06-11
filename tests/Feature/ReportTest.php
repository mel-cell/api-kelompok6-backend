<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\Post;
use App\Models\Report;
use App\Models\Role;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ReportTest extends TestCase
{
    use RefreshDatabase;

    protected User $user;

    protected User $admin;

    protected string $userToken;

    protected string $adminToken;

    protected Post $post;

    protected function setUp(): void
    {
        parent::setUp();
        $userRole = Role::create(['id' => fake()->uuid(), 'name' => 'user', 'permissions' => []]);
        $adminRole = Role::create(['id' => fake()->uuid(), 'name' => 'admin', 'permissions' => ['*']]);
        $this->user = User::create([
            'username' => 'budi', 'email' => 'budi@example.com',
            'password_hash' => bcrypt('password'),
        ]);
        $this->user->roles()->attach($userRole->id, ['assigned_at' => now()]);
        $this->userToken = $this->user->createToken('auth-token')->plainTextToken;

        $this->admin = User::create([
            'username' => 'admin', 'email' => 'admin@example.com',
            'password_hash' => bcrypt('password'),
        ]);
        $this->admin->roles()->attach($adminRole->id, ['assigned_at' => now()]);
        $this->adminToken = $this->admin->createToken('auth-token')->plainTextToken;

        $category = Category::create([
            'id' => fake()->uuid(), 'name' => 'Teknologi', 'slug' => 'teknologi',
        ]);
        $this->post = Post::create([
            'user_id' => $this->user->id, 'category_id' => $category->id,
            'title' => 'Post', 'body' => 'Body',
        ]);
    }

    public function test_reasons_public(): void
    {
        $response = $this->getJson('/api/v1/reports/reasons');

        $response->assertStatus(200)
            ->assertJsonStructure(['success', 'message', 'data']);
    }

    public function test_store_success(): void
    {
        $response = $this->withToken($this->userToken)->postJson('/api/v1/reports', [
            'target_id' => $this->post->id,
            'target_type' => 'post',
            'reason' => 'spam',
            'description' => 'Ini spam',
        ]);

        $response->assertStatus(201)
            ->assertJsonPath('data.reason', 'spam');
    }

    public function test_store_unauthenticated(): void
    {
        $response = $this->postJson('/api/v1/reports', [
            'target_id' => fake()->uuid(),
            'target_type' => 'post',
            'reason' => 'spam',
        ]);
        $response->assertStatus(401);
    }

    public function test_index_as_admin(): void
    {
        Report::create([
            'reporter_id' => $this->user->id,
            'target_id' => $this->post->id,
            'target_type' => 'post',
            'reason' => 'spam',
            'status' => 'pending',
            'created_at' => now(),
        ]);

        $response = $this->withToken($this->adminToken)->getJson('/api/v1/reports');

        $response->assertStatus(200)
            ->assertJsonStructure(['success', 'message', 'data']);
    }

    public function test_index_as_user_forbidden(): void
    {
        $response = $this->withToken($this->userToken)->getJson('/api/v1/reports');
        $response->assertStatus(403);
    }

    public function test_show_as_admin(): void
    {
        $report = Report::create([
            'reporter_id' => $this->user->id,
            'target_id' => $this->post->id,
            'target_type' => 'post',
            'reason' => 'spam',
            'status' => 'pending',
            'created_at' => now(),
        ]);

        $response = $this->withToken($this->adminToken)->getJson(
            "/api/v1/reports/{$report->id}"
        );

        $response->assertStatus(200);
    }

    public function test_resolve_as_admin(): void
    {
        $report = Report::create([
            'reporter_id' => $this->user->id,
            'target_id' => $this->post->id,
            'target_type' => 'post',
            'reason' => 'spam',
            'status' => 'pending',
            'created_at' => now(),
        ]);

        $response = $this->withToken($this->adminToken)->patchJson(
            "/api/v1/reports/{$report->id}/resolve",
            ['status' => 'resolved']
        );

        $response->assertStatus(200)
            ->assertJsonPath('data.status', 'resolved');
    }
}
