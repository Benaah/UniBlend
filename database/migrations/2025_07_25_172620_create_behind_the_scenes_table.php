<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('behind_the_scenes', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->string('artist_name');
            $table->text('description');
            $table->string('thumbnail_url')->nullable();
            $table->json('media_urls')->nullable(); // array of media file URLs
            $table->enum('media_type', ['photos', 'videos', 'mixed'])->default('mixed');
            $table->datetime('published_at')->nullable();
            $table->boolean('is_local')->default(true);
            $table->boolean('is_featured')->default(false);
            $table->bigInteger('view_count')->default(0);
            $table->enum('status', ['draft', 'published', 'archived'])->default('draft');
            $table->string('location')->nullable();
            $table->string('studio_name')->nullable();
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
        Schema::dropIfExists('behind_the_scenes');
    }
};
