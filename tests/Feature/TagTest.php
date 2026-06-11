<?php

namespace Tests\Feature;

use App\Models\Tag;
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
}
