<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('challenge_submissions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('music_challenge_id')->constrained()->onDelete('cascade');
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('title');
            $table->text('description')->nullable();
            $table->string('media_url'); // video/audio file URL
            $table->enum('media_type', ['video', 'audio', 'image'])->default('video');
            $table->string('thumbnail_url')->nullable();
            $table->integer('duration')->nullable(); // duration in seconds
            $table->enum('status', ['pending', 'approved', 'rejected'])->default('pending');
            $table->datetime('submission_date')->default(now());
            $table->bigInteger('votes_count')->default(0);
            $table->integer('admin_score')->nullable(); // 1-10 rating by admin
            $table->boolean('is_winner')->default(false);
            $table->json('social_media_links')->nullable(); // links to social media posts
            $table->json('metadata')->nullable();
            $table->timestamps();
            $table->softDeletes();

            $table->unique(['music_challenge_id', 'user_id']);
            $table->index(['status', 'submission_date']);
            $table->index(['is_winner', 'votes_count']);
            $table->index('votes_count');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('challenge_submissions');
    }
};
