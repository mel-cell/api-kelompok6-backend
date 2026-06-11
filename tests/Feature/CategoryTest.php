<?php

namespace Tests\Feature;

use App\Models\Category;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class CategoryTest extends TestCase
{
    use RefreshDatabase;

    public function test_index_success(): void
    {
        Category::create(['id' => fake()->uuid(), 'name' => 'Teknologi', 'slug' => 'teknologi']);
        Category::create(['id' => fake()->uuid(), 'name' => 'Olahraga', 'slug' => 'olahraga']);

        $response = $this->getJson('/api/v1/categories');

        $response->assertStatus(200)
            ->assertJsonStructure(['success', 'message', 'data']);
    }

    public function test_show_success(): void
    {
        $category = Category::create([
            'id' => fake()->uuid(), 'name' => 'Teknologi', 'slug' => 'teknologi',
        ]);

        $response = $this->getJson("/api/v1/categories/{$category->id}");

        $response->assertStatus(200)
            ->assertJsonPath('data.name', 'Teknologi');
    }

    public function test_show_not_found(): void
    {
        $response = $this->getJson('/api/v1/categories/'.fake()->uuid());
        $response->assertStatus(404);
    }
}
