<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('submission_votes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('challenge_submission_id')->constrained()->onDelete('cascade');
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->enum('vote_type', ['up', 'down'])->default('up');
            $table->timestamps();

            $table->unique(['challenge_submission_id', 'user_id']);
            $table->index('vote_type');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('submission_votes');
    }
};
