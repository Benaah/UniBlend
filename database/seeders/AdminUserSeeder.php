<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;

class AdminUserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        User::factory()->create([
            'name' => 'Ben John',
            'email' => 'barnerdosilver@gmail.com',
            'role' => 'admin',
        ]);
    }
}
