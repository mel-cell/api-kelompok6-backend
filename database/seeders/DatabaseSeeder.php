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
            'reputation_points' => 0,
            'level' => 1,
        ]);

        $adminRole = Role::where('name', 'admin')->first();
        if ($adminRole) {
            $admin->roles()->attach($adminRole->id, ['assigned_at' => now()]);
        }

        $user = User::create([
            'username' => 'user',
            'email' => 'user@forum.test',
            'password_hash' => Hash::make('password'),
            'reputation_points' => 0,
            'level' => 1,
        ]);

        $userRole = Role::where('name', 'user')->first();
        if ($userRole) {
            $user->roles()->attach($userRole->id, ['assigned_at' => now()]);
        }
    }
}
