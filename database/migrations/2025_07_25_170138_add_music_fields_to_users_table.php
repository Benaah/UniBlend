<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->foreignId('profile_music_track_id')->nullable()->constrained('music_tracks')->onDelete('set null');
            $table->json('favorite_genres')->nullable();
            $table->json('music_preferences')->nullable();
            
            $table->index('profile_music_track_id');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropForeign(['profile_music_track_id']);
            $table->dropColumn([
                'profile_music_track_id',
                'favorite_genres',
                'music_preferences'
            ]);
        });
    }
};
