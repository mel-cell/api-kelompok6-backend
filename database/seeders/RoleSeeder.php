<?php

namespace Database\Seeders;

use App\Models\Role;
use Illuminate\Database\Seeder;

class RoleSeeder extends Seeder
{
    public function run(): void
    {
        Role::create(['name' => 'admin', 'permissions' => ['*']]);
        Role::create(['name' => 'moderator', 'permissions' => [
            'edit_posts', 'delete_posts', 'edit_comments', 'delete_comments',
            'resolve_reports', 'ban_users',
        ]]);
        Role::create(['name' => 'user', 'permissions' => [
            'create_posts', 'edit_own_posts', 'delete_own_posts',
            'create_comments', 'edit_own_comments', 'delete_own_comments',
            'vote', 'like', 'bookmark', 'follow', 'report',
        ]]);
    }
}
