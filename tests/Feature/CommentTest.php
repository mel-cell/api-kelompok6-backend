<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\Comment;
use App\Models\Post;
use App\Models\Role;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class CommentTest extends TestCase
{
    use RefreshDatabase;

    protected User $user;

    protected string $token;

    protected Post $post;

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
        $this->post = Post::create([
            'user_id' => $this->user->id, 'category_id' => $category->id,
            'title' => 'Post', 'body' => 'Body',
        ]);
    }

    public function test_index_success(): void
    {
        Comment::create([
            'post_id' => $this->post->id, 'user_id' => $this->user->id, 'body' => 'Komentar 1',
        ]);

        $response = $this->getJson("/api/v1/posts/{$this->post->id}/comments");

        $response->assertStatus(200)
            ->assertJsonStructure(['success', 'message', 'data']);
    }

    public function test_store_success(): void
    {
        $response = $this->withToken($this->token)->postJson(
            "/api/v1/posts/{$this->post->id}/comments",
            ['body' => 'Komentar baru']
        );

        $response->assertStatus(201)
            ->assertJsonPath('data.body', 'Komentar baru');
    }

    public function test_store_unauthenticated(): void
    {
        $response = $this->postJson(
            "/api/v1/posts/{$this->post->id}/comments",
            ['body' => 'Komentar']
        );
        $response->assertStatus(401);
    }

    public function test_update_own_comment_success(): void
    {
        $comment = Comment::create([
            'post_id' => $this->post->id, 'user_id' => $this->user->id, 'body' => 'Lama',
        ]);

        $response = $this->withToken($this->token)->putJson(
            "/api/v1/comments/{$comment->id}",
            ['body' => 'Diedit']
        );

        $response->assertStatus(200)
            ->assertJsonPath('data.body', 'Diedit');
    }

    public function test_destroy_own_comment_success(): void
    {
        $comment = Comment::create([
            'post_id' => $this->post->id, 'user_id' => $this->user->id, 'body' => 'Hapus ini',
        ]);

        $response = $this->withToken($this->token)->deleteJson(
            "/api/v1/comments/{$comment->id}"
        );

        $response->assertStatus(200);
        $this->assertNull($comment->fresh());
    }
}
