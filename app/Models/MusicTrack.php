<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class MusicTrack extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'title',
        'artist',
        'album',
        'genre',
        'duration',
        'file_url',
        'cover_image',
        'release_date',
        'language',
        'country',
        'lyrics',
        'is_local',
        'is_featured',
        'play_count',
        'status',
        'uploaded_by',
        'metadata',
    ];

    protected $casts = [
        'release_date' => 'date',
        'is_local' => 'boolean',
        'is_featured' => 'boolean',
        'metadata' => 'array',
    ];

    public function uploader()
    {
        return $this->belongsTo(User::class, 'uploaded_by');
    }

    public function playlists()
    {
        return $this->belongsToMany(Playlist::class, 'playlist_tracks')->withTimestamps();
    }

    public function posts()
    {
        return $this->hasMany(Post::class, 'music_track_id');
    }

    public function threads()
    {
        return $this->hasMany(Thread::class, 'music_track_id');
    }

    public function userFavorites()
    {
        return $this->belongsToMany(User::class, 'user_favorite_tracks')->withTimestamps();
    }

    public function scopeLocal($query)
    {
        return $query->where('is_local', true);
    }

    public function scopeFeatured($query)
    {
        return $query->where('is_featured', true);
    }

    public function scopeByGenre($query, $genre)
    {
        return $query->where('genre', $genre);
    }

    public function scopePopular($query)
    {
        return $query->orderBy('play_count', 'desc');
    }

    public function getDurationFormattedAttribute()
    {
        $minutes = floor($this->duration / 60);
        $seconds = $this->duration % 60;
        return sprintf('%d:%02d', $minutes, $seconds);
    }
}
