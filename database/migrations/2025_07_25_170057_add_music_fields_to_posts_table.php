<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('posts', function (Blueprint $table) {
            $table->foreignId('music_track_id')->nullable()->constrained()->onDelete('set null');
            $table->integer('music_start_time')->nullable(); // start time in seconds
            $table->integer('music_end_time')->nullable(); // end time in seconds
            $table->enum('status', ['published', 'draft', 'flagged', 'pending', 'removed'])->default('published');
            $table->boolean('is_featured')->default(false);
            $table->boolean('allow_comments')->default(true);
            
            $table->index(['status', 'created_at']);
            $table->index('music_track_id');
        });
    }

    public function down(): void
    {
        Schema::table('posts', function (Blueprint $table) {
            $table->dropForeign(['music_track_id']);
            $table->dropColumn([
                'music_track_id',
                'music_start_time', 
                'music_end_time',
                'status',
                'is_featured',
                'allow_comments'
            ]);
        });
    }
};
