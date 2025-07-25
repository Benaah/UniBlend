<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;

class RoleSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Create permissions
        $permissions = [
            'view users',
            'create users',
            'edit users',
            'delete users',
            'view threads',
            'create threads',
            'edit threads',
            'delete threads',
            'view posts',
            'create posts',
            'edit posts',
            'delete posts',
            'view bookings',
            'create bookings',
            'edit bookings',
            'delete bookings',
            'manage wallets',
            'view admin panel',
            'manage settings',
            'view reports',
        ];

        foreach ($permissions as $permission) {
            Permission::firstOrCreate(['name' => $permission]);
        }

        // Create roles
        $adminRole = Role::firstOrCreate(['name' => 'admin']);
        $moderatorRole = Role::firstOrCreate(['name' => 'moderator']);
        $userRole = Role::firstOrCreate(['name' => 'user']);

        // Assign permissions to roles
        $adminRole->givePermissionTo(Permission::all());
        
        $moderatorRole->givePermissionTo([
            'view users',
            'view threads',
            'create threads',
            'edit threads',
            'delete threads',
            'view posts',
            'create posts',
            'edit posts',
            'delete posts',
            'view bookings',
            'edit bookings',
        ]);

        $userRole->givePermissionTo([
            'view threads',
            'create threads',
            'edit threads', // only own
            'view posts',
            'create posts',
            'edit posts', // only own
            'view bookings',
            'create bookings',
            'edit bookings', // only own
        ]);
    }
}
