<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('artist_interviews', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->string('artist_name');
            $table->text('description');
            $table->string('thumbnail_url')->nullable();
            $table->string('video_url')->nullable();
            $table->string('audio_url')->nullable();
            $table->integer('duration')->nullable(); // duration in seconds
            $table->datetime('published_at')->nullable();
            $table->boolean('is_local')->default(true);
            $table->boolean('is_featured')->default(false);
            $table->bigInteger('view_count')->default(0);
            $table->enum('status', ['draft', 'published', 'archived'])->default('draft');
            $table->string('interviewer')->nullable();
            $table->json('tags')->nullable();
            $table->json('metadata')->nullable();
            $table->timestamps();
            $table->softDeletes();

            $table->index(['status', 'published_at']);
            $table->index(['is_local', 'is_featured']);
            $table->index('view_count');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('artist_interviews');
    }
};
