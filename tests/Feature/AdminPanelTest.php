<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AdminPanelTest extends TestCase
{
    use RefreshDatabase;

    public function test_admin_panel_redirects_to_login_when_not_authenticated()
    {
        $response = $this->get('/admin');
        
        $response->assertRedirect('/admin/login');
    }

    public function test_admin_panel_loads_for_authenticated_user()
    {
        $user = User::factory()->create([
            'role' => 'admin'
        ]);

        $response = $this->actingAs($user)->get('/admin');
        
        $response->assertStatus(200);
    }

    public function test_admin_can_access_users_resource()
    {
        $user = User::factory()->create([
            'role' => 'admin'
        ]);

        $response = $this->actingAs($user)->get('/admin/users');
        
        $response->assertStatus(200);
    }

    public function test_admin_can_access_posts_resource()
    {
        $user = User::factory()->create([
            'role' => 'admin'
        ]);

        $response = $this->actingAs($user)->get('/admin/posts');
        
        $response->assertStatus(200);
    }

    public function test_admin_can_access_threads_resource()
    {
        $user = User::factory()->create([
            'role' => 'admin'
        ]);

        $response = $this->actingAs($user)->get('/admin/threads');
        
        $response->assertStatus(200);
    }

    public function test_admin_can_access_bookings_resource()
    {
        $user = User::factory()->create([
            'role' => 'admin'
        ]);

        $response = $this->actingAs($user)->get('/admin/bookings');
        
        $response->assertStatus(200);
    }

    public function test_admin_can_access_music_tracks_resource()
    {
        $user = User::factory()->create([
            'role' => 'admin'
        ]);

        $response = $this->actingAs($user)->get('/admin/music-tracks');
        
        $response->assertStatus(200);
    }

    public function test_admin_can_access_playlists_resource()
    {
        $user = User::factory()->create([
            'role' => 'admin'
        ]);

        $response = $this->actingAs($user)->get('/admin/playlists');
        
        $response->assertStatus(200);
    }

    public function test_admin_can_access_music_genres_resource()
    {
        $user = User::factory()->create([
            'role' => 'admin'
        ]);

        $response = $this->actingAs($user)->get('/admin/music-genres');
        
        $response->assertStatus(200);
    }
}
