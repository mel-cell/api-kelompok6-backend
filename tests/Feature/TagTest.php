<?php

namespace Tests\Feature;

use App\Models\Tag;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class TagTest extends TestCase
{
    use RefreshDatabase;

    public function test_index_success(): void
    {
        Tag::create(['id' => fake()->uuid(), 'name' => 'laravel', 'slug' => 'laravel', 'color' => '#ff0000']);
        Tag::create(['id' => fake()->uuid(), 'name' => 'php', 'slug' => 'php', 'color' => '#00ff00']);

        $response = $this->getJson('/api/v1/tags');

        $response->assertStatus(200)
            ->assertJsonStructure(['success', 'message', 'data']);
    }

    public function test_show_success(): void
    {
        $tag = Tag::create([
            'id' => fake()->uuid(), 'name' => 'laravel', 'slug' => 'laravel', 'color' => '#ff0000',
        ]);

        $response = $this->getJson("/api/v1/tags/{$tag->id}");

        $response->assertStatus(200)
            ->assertJsonPath('data.name', 'laravel');
    }

    public function test_show_not_found(): void
    {
        $response = $this->getJson('/api/v1/tags/'.fake()->uuid());
        $response->assertStatus(404);
    }

    public function test_store_success_by_regular_user(): void
    {
        $user = User::factory()->create();
        $token = $user->createToken('test')->plainTextToken;

        $response = $this->withToken($token)->postJson('/api/v1/tags', [
            'name' => 'laravel',
            'slug' => 'laravel',
            'color' => '#ff2d20',
        ]);

        $response->assertStatus(201)
            ->assertJsonPath('data.name', 'laravel');
    }

    public function test_store_validation_fails(): void
    {
        $user = User::factory()->create();
        $token = $user->createToken('test')->plainTextToken;

        $response = $this->withToken($token)->postJson('/api/v1/tags', [
            'name' => '',
        ]);

        $response->assertStatus(422);
    }

    public function test_store_unauthenticated(): void
    {
        $response = $this->postJson('/api/v1/tags', [
            'name' => 'laravel',
            'slug' => 'laravel',
        ]);

        $response->assertStatus(401);
    }
}
