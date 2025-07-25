<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Playlist extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'name',
        'description',
        'cover_image',
        'user_id',
        'is_public',
        'is_featured',
        'play_count',
        'status',
    ];

    protected $casts = [
        'is_public' => 'boolean',
        'is_featured' => 'boolean',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function tracks()
    {
        return $this->belongsToMany(MusicTrack::class, 'playlist_tracks')->withTimestamps()->withPivot('order');
    }

    public function followers()
    {
        return $this->belongsToMany(User::class, 'playlist_followers')->withTimestamps();
    }

    public function scopePublic($query)
    {
        return $query->where('is_public', true);
    }

    public function scopeFeatured($query)
    {
        return $query->where('is_featured', true);
    }

    public function getTotalDurationAttribute()
    {
        return $this->tracks->sum('duration');
    }

    public function getTracksCountAttribute()
    {
        return $this->tracks->count();
    }
}
