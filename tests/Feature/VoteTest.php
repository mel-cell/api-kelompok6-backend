<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\Comment;
use App\Models\Post;
use App\Models\Role;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class VoteTest extends TestCase
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

    public function test_toggle_post_upvote(): void
    {
        $response = $this->withToken($this->token)->postJson(
            "/api/v1/posts/{$this->post->id}/vote",
            ['vote_type' => 'upvote']
        );

        $response->assertStatus(201)
            ->assertJsonStructure(['success', 'message', 'data' => ['vote_type', 'vote_score']])
            ->assertJsonPath('data.vote_type', 'upvote');
    }

    public function test_toggle_post_downvote(): void
    {
        $response = $this->withToken($this->token)->postJson(
            "/api/v1/posts/{$this->post->id}/vote",
            ['vote_type' => 'downvote']
        );

        $response->assertStatus(201)
            ->assertJsonPath('data.vote_type', 'downvote');
    }

    public function test_toggle_comment_upvote(): void
    {
        $response = $this->withToken($this->token)->postJson(
            "/api/v1/comments/{$this->comment->id}/vote",
            ['vote_type' => 'upvote']
        );

        $response->assertStatus(201)
            ->assertJsonPath('data.vote_type', 'upvote');
    }

    public function test_toggle_vote_validation_error(): void
    {
        $response = $this->withToken($this->token)->postJson(
            "/api/v1/posts/{$this->post->id}/vote",
            ['vote_type' => 'invalid']
        );

        $response->assertStatus(422);
    }
}
