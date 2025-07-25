<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('threads', function (Blueprint $table) {
            $table->foreignId('music_track_id')->nullable()->constrained()->onDelete('set null');
            $table->string('category')->nullable();
            $table->enum('status', ['active', 'inactive', 'flagged', 'pending'])->default('active');
            $table->boolean('is_pinned')->default(false);
            $table->boolean('is_music_related')->default(false);
            
            $table->index(['status', 'created_at']);
            $table->index(['category', 'status']);
            $table->index('music_track_id');
            $table->index('is_music_related');
        });
    }

    public function down(): void
    {
        Schema::table('threads', function (Blueprint $table) {
            $table->dropForeign(['music_track_id']);
            $table->dropColumn([
                'music_track_id',
                'category',
                'status',
                'is_pinned',
                'is_music_related'
            ]);
        });
    }
};
