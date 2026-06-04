<?php

namespace Database\Seeders;

use App\Models\Role;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $this->call([
            RoleSeeder::class,
            CategorySeeder::class,
            TagSeeder::class,
        ]);

        $admin = User::create([
            'username' => 'admin',
            'email' => 'admin@forum.test',
            'password_hash' => Hash::make('password'),
            'reputation_points' => 150,
            'level' => 5,
        ]);

        $moderator = User::create([
            'username' => 'moderator',
            'email' => 'moderator@forum.test',
            'password_hash' => Hash::make('password'),
            'reputation_points' => 80,
            'level' => 3,
        ]);

        $user = User::create([
            'username' => 'user',
            'email' => 'user@forum.test',
            'password_hash' => Hash::make('password'),
            'reputation_points' => 25,
            'level' => 2,
        ]);

        $adminRole = Role::where('name', 'admin')->first();
        if ($adminRole) {
            $admin->roles()->attach($adminRole->id, ['assigned_at' => now()]);
        }

        $modRole = Role::where('name', 'moderator')->first();
        if ($modRole) {
            $moderator->roles()->attach($modRole->id, ['assigned_at' => now()]);
        }

        $userRole = Role::where('name', 'user')->first();
        if ($userRole) {
            $user->roles()->attach($userRole->id, ['assigned_at' => now()]);
        }

        $this->call(PostSeeder::class);
    }
}
