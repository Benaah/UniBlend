<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('music_events', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->text('description');
            $table->string('venue_name');
            $table->text('venue_address');
            $table->decimal('latitude', 10, 8)->nullable();
            $table->decimal('longitude', 11, 8)->nullable();
            $table->date('event_date');
            $table->datetime('start_time');
            $table->datetime('end_time')->nullable();
            $table->decimal('ticket_price', 8, 2)->default(0);
            $table->string('ticket_url')->nullable();
            $table->string('event_type')->nullable(); // concert, festival, club_night, etc.
            $table->string('genre')->nullable();
            $table->json('artists')->nullable(); // array of artist names
            $table->string('organizer')->nullable();
            $table->json('contact_info')->nullable();
            $table->string('banner_image')->nullable();
            $table->boolean('is_featured')->default(false);
            $table->boolean('is_local')->default(true);
            $table->enum('status', ['draft', 'published', 'cancelled', 'completed'])->default('draft');
            $table->integer('capacity')->nullable();
            $table->integer('tickets_sold')->default(0);
            $table->string('age_restriction')->nullable(); // 18+, 21+, all_ages
            $table->json('metadata')->nullable();
            $table->timestamps();
            $table->softDeletes();

            $table->index(['event_date', 'status']);
            $table->index(['is_featured', 'is_local']);
            $table->index(['genre', 'event_date']);
            $table->index(['latitude', 'longitude']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('music_events');
    }
};
