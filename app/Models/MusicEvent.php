<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class MusicEvent extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'title',
        'description',
        'venue_name',
        'venue_address',
        'latitude',
        'longitude',
        'event_date',
        'start_time',
        'end_time',
        'ticket_price',
        'ticket_url',
        'event_type',
        'genre',
        'artists',
        'organizer',
        'contact_info',
        'banner_image',
        'is_featured',
        'is_local',
        'status',
        'capacity',
        'tickets_sold',
        'age_restriction',
        'metadata',
    ];

    protected $casts = [
        'event_date' => 'date',
        'start_time' => 'datetime',
        'end_time' => 'datetime',
        'artists' => 'array',
        'contact_info' => 'array',
        'is_featured' => 'boolean',
        'is_local' => 'boolean',
        'metadata' => 'array',
    ];

    public function scopeUpcoming($query)
    {
        return $query->where('event_date', '>=', now()->toDateString())
                    ->where('status', 'published');
    }

    public function scopeFeatured($query)
    {
        return $query->where('is_featured', true);
    }

    public function scopeLocal($query)
    {
        return $query->where('is_local', true);
    }

    public function scopeByGenre($query, $genre)
    {
        return $query->where('genre', $genre);
    }

    public function getTicketPriceFormattedAttribute()
    {
        if ($this->ticket_price == 0) return 'Free';
        return 'KSh ' . number_format($this->ticket_price, 0);
    }

    public function getTicketsAvailableAttribute()
    {
        if (!$this->capacity) return null;
        return $this->capacity - $this->tickets_sold;
    }

    public function isSoldOut()
    {
        return $this->capacity && $this->tickets_sold >= $this->capacity;
    }

    public function isPast()
    {
        return $this->event_date < now()->toDateString();
    }

    public function isToday()
    {
        return $this->event_date === now()->toDateString();
    }

    public function getEventStatusAttribute()
    {
        if ($this->isPast()) return 'past';
        if ($this->isToday()) return 'today';
        if ($this->isSoldOut()) return 'sold_out';
        return 'upcoming';
    }
}
