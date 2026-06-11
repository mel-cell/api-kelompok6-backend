<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\Comment;
use App\Models\Post;
use App\Models\Role;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class LikeTest extends TestCase
{
    use RefreshDatabase;

    protected User $user;

    protected string $token;

    protected Post $post;

    protected Comment $comment;

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
        $this->comment = Comment::create([
            'post_id' => $this->post->id, 'user_id' => $this->user->id, 'body' => 'Komentar',
        ]);
    }

    public function test_toggle_post_like_add(): void
    {
        $response = $this->withToken($this->token)->postJson(
            "/api/v1/posts/{$this->post->id}/like"
        );

        $response->assertStatus(201)
            ->assertJsonPath('data.liked', true);
    }

    public function test_toggle_post_like_remove(): void
    {
        $this->withToken($this->token)->postJson("/api/v1/posts/{$this->post->id}/like");

        $response = $this->withToken($this->token)->postJson(
            "/api/v1/posts/{$this->post->id}/like"
        );

        $response->assertStatus(200)
            ->assertJsonPath('data.liked', false);
    }

    public function test_toggle_comment_like_add(): void
    {
        $response = $this->withToken($this->token)->postJson(
            "/api/v1/comments/{$this->comment->id}/like"
        );

        $response->assertStatus(201)
            ->assertJsonPath('data.liked', true);
    }

    public function test_toggle_comment_like_unauthenticated(): void
    {
        $response = $this->postJson("/api/v1/comments/{$this->comment->id}/like");
        $response->assertStatus(401);
    }
}
