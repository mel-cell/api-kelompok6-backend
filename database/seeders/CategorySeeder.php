<?php

namespace Database\Seeders;

use App\Models\Category;
use Illuminate\Database\Seeder;

class CategorySeeder extends Seeder
{
    public function run(): void
    {
        $categories = [
            ['name' => 'Programming', 'slug' => 'programming'],
            ['name' => 'Web Development', 'slug' => 'web-development', 'parent_id' => null],
            ['name' => 'Mobile Development', 'slug' => 'mobile-development'],
            ['name' => 'Design & UX', 'slug' => 'design-ux'],
            ['name' => 'Database', 'slug' => 'database'],
            ['name' => 'DevOps & Infrastructure', 'slug' => 'devops'],
            ['name' => 'Artificial Intelligence', 'slug' => 'ai'],
            ['name' => 'Security', 'slug' => 'security'],
            ['name' => 'Career & Discussion', 'slug' => 'career'],
        ];

        foreach ($categories as $cat) {
            Category::create($cat);
        }
    }
}
