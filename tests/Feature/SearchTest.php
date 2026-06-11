<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\Post;
use App\Models\Role;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class SearchTest extends TestCase
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

        $category = Category::create([
            'id' => fake()->uuid(), 'name' => 'Teknologi', 'slug' => 'teknologi',
        ]);
        Post::create([
            'user_id' => $this->user->id, 'category_id' => $category->id,
            'title' => 'Cara menggunakan Laravel', 'body' => 'Panduan lengkap Laravel',
        ]);
    }

    public function test_search_posts_success(): void
    {
        $response = $this->withToken($this->token)->getJson('/api/v1/search/posts?q=Laravel');

        $response->assertStatus(200)
            ->assertJsonStructure(['success', 'message', 'data']);
    }

    public function test_search_posts_empty_query(): void
    {
        $response = $this->withToken($this->token)->getJson('/api/v1/search/posts?q=');
        $response->assertStatus(422);
    }

    public function test_search_unauthenticated(): void
    {
        $response = $this->getJson('/api/v1/search/posts?q=test');
        $response->assertStatus(401);
    }
}
