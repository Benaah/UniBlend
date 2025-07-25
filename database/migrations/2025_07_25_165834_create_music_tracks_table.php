<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('music_tracks', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->string('artist');
            $table->string('album')->nullable();
            $table->string('genre')->nullable();
            $table->integer('duration')->nullable(); // duration in seconds
            $table->string('file_url');
            $table->string('cover_image')->nullable();
            $table->date('release_date')->nullable();
            $table->string('language')->default('en');
            $table->string('country')->default('KE');
            $table->text('lyrics')->nullable();
            $table->boolean('is_local')->default(true);
            $table->boolean('is_featured')->default(false);
            $table->bigInteger('play_count')->default(0);
            $table->enum('status', ['active', 'inactive', 'pending', 'rejected'])->default('active');
            $table->foreignId('uploaded_by')->nullable()->constrained('users')->onDelete('set null');
            $table->json('metadata')->nullable();
            $table->timestamps();
            $table->softDeletes();

            $table->index(['is_local', 'status']);
            $table->index(['genre', 'status']);
            $table->index(['artist', 'status']);
            $table->index('play_count');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('music_tracks');
    }
};
