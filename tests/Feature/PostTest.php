<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\Comment;
use App\Models\Post;
use App\Models\Role;
use App\Models\Tag;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class PostTest extends TestCase
{
    use RefreshDatabase;

    protected User $user;

    protected User $moderator;

    protected string $token;

    protected Category $category;

    protected Tag $tag;

    protected function setUp(): void
    {
        parent::setUp();
        Role::create(['id' => fake()->uuid(), 'name' => 'user', 'permissions' => []]);
        Role::create(['id' => fake()->uuid(), 'name' => 'moderator', 'permissions' => []]);
        $this->user = User::create([
            'username' => 'budi', 'email' => 'budi@example.com',
            'password_hash' => bcrypt('password'),
        ]);
        $this->moderator = User::create([
            'username' => 'mod', 'email' => 'mod@example.com',
            'password_hash' => bcrypt('password'),
        ]);
        $this->token = $this->user->createToken('auth-token')->plainTextToken;
        $this->category = Category::create([
            'id' => fake()->uuid(), 'name' => 'Teknologi', 'slug' => 'teknologi',
        ]);
        $this->tag = Tag::create([
            'id' => fake()->uuid(), 'name' => 'laravel', 'slug' => 'laravel', 'color' => '#ff0000',
        ]);
    }

    public function test_index_success(): void
    {
        Post::create([
            'user_id' => $this->user->id, 'category_id' => $this->category->id,
            'title' => 'Post 1', 'body' => 'Body 1',
        ]);

        $response = $this->getJson('/api/v1/posts');

        $response->assertStatus(200)
            ->assertJsonStructure(['success', 'message', 'data', 'meta', 'links']);
    }

    public function test_show_success(): void
    {
        $post = Post::create([
            'user_id' => $this->user->id, 'category_id' => $this->category->id,
            'title' => 'Post 1', 'body' => 'Body 1',
        ]);

        $response = $this->getJson("/api/v1/posts/{$post->id}");

        $response->assertStatus(200)
            ->assertJsonPath('data.title', 'Post 1');
    }

    public function test_show_not_found(): void
    {
        $response = $this->getJson('/api/v1/posts/'.fake()->uuid());
        $response->assertStatus(404);
    }

    public function test_store_success(): void
    {
        $response = $this->withToken($this->token)->postJson('/api/v1/posts', [
            'category_id' => $this->category->id,
            'title' => 'Judul Post Baru',
            'body' => 'Isi post yang panjang',
        ]);

        $response->assertStatus(201)
            ->assertJsonPath('data.title', 'Judul Post Baru');
    }

    public function test_store_unauthenticated(): void
    {
        $response = $this->postJson('/api/v1/posts', [
            'category_id' => $this->category->id,
            'title' => 'Judul', 'body' => 'Body',
        ]);
        $response->assertStatus(401);
    }

    public function test_store_validation_error(): void
    {
        $response = $this->withToken($this->token)->postJson('/api/v1/posts', [
            'category_id' => 'not-uuid',
            'title' => '',
            'body' => '',
        ]);
        $response->assertStatus(422);
    }

    public function test_update_own_post_success(): void
    {
        $post = Post::create([
            'user_id' => $this->user->id, 'category_id' => $this->category->id,
            'title' => 'Lama', 'body' => 'Body lama',
        ]);

        $response = $this->withToken($this->token)->putJson("/api/v1/posts/{$post->id}", [
            'title' => 'Judul Baru',
            'body' => 'Body baru',
        ]);

        $response->assertStatus(200)
            ->assertJsonPath('data.title', 'Judul Baru');
    }

    public function test_update_not_owner_forbidden(): void
    {
        $otherUser = User::create([
            'username' => 'orang', 'email' => 'orang@example.com',
            'password_hash' => bcrypt('password'),
        ]);
        $post = Post::create([
            'user_id' => $otherUser->id, 'category_id' => $this->category->id,
            'title' => 'Lama', 'body' => 'Body lama',
        ]);

        $response = $this->withToken($this->token)->putJson("/api/v1/posts/{$post->id}", [
            'title' => 'Judul Baru',
        ]);

        $response->assertStatus(403);
    }

    public function test_destroy_own_post_success(): void
    {
        $post = Post::create([
            'user_id' => $this->user->id, 'category_id' => $this->category->id,
            'title' => 'Post', 'body' => 'Body',
        ]);

        $response = $this->withToken($this->token)->deleteJson("/api/v1/posts/{$post->id}");

        $response->assertStatus(200);
        $this->assertEquals('deleted', $post->fresh()->status);
    }

    public function test_toggle_bookmark(): void
    {
        $post = Post::create([
            'user_id' => $this->user->id, 'category_id' => $this->category->id,
            'title' => 'Post', 'body' => 'Body',
        ]);

        $response = $this->withToken($this->token)->postJson("/api/v1/posts/{$post->id}/bookmark");

        $response->assertStatus(200)
            ->assertJsonPath('data.is_bookmarked', true);
    }

    public function test_accept_answer_success(): void
    {
        $post = Post::create([
            'user_id' => $this->user->id, 'category_id' => $this->category->id,
            'title' => 'Post', 'body' => 'Body',
        ]);
        $comment = Comment::create([
            'post_id' => $post->id, 'user_id' => $this->user->id,
            'body' => 'Jawaban',
        ]);

        $response = $this->withToken($this->token)->patchJson(
            "/api/v1/posts/{$post->id}/accept/{$comment->id}"
        );

        $response->assertStatus(200);
        $this->assertTrue($post->fresh()->is_answered);
    }
}
