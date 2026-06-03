<?php

namespace Database\Seeders;

use App\Models\Tag;
use Illuminate\Database\Seeder;

class TagSeeder extends Seeder
{
    public function run(): void
    {
        $tags = [
            ['name' => 'PHP', 'slug' => 'php', 'color' => '#777BB3'],
            ['name' => 'Laravel', 'slug' => 'laravel', 'color' => '#FF2D20'],
            ['name' => 'JavaScript', 'slug' => 'javascript', 'color' => '#F7DF1E'],
            ['name' => 'TypeScript', 'slug' => 'typescript', 'color' => '#3178C6'],
            ['name' => 'React', 'slug' => 'react', 'color' => '#61DAFB'],
            ['name' => 'Vue.js', 'slug' => 'vuejs', 'color' => '#4FC08D'],
            ['name' => 'Go', 'slug' => 'go', 'color' => '#00ADD8'],
            ['name' => 'Python', 'slug' => 'python', 'color' => '#3776AB'],
            ['name' => 'Java', 'slug' => 'java', 'color' => '#007396'],
            ['name' => 'Docker', 'slug' => 'docker', 'color' => '#2496ED'],
            ['name' => 'MySQL', 'slug' => 'mysql', 'color' => '#4479A1'],
            ['name' => 'PostgreSQL', 'slug' => 'postgresql', 'color' => '#4169E1'],
            ['name' => 'Redis', 'slug' => 'redis', 'color' => '#DC382D'],
            ['name' => 'REST API', 'slug' => 'rest-api', 'color' => '#6DB33F'],
            ['name' => 'Tailwind CSS', 'slug' => 'tailwind-css', 'color' => '#06B6D4'],
        ];

        foreach ($tags as $tag) {
            Tag::create($tag);
        }
    }
}
