<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('playlist_followers', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('playlist_id')->constrained()->onDelete('cascade');
            $table->timestamps();

            $table->unique(['user_id', 'playlist_id']);
            $table->index('playlist_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('playlist_followers');
    }
};
