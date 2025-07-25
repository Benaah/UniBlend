<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Post extends Model
{
    use HasFactory;

    protected $fillable = [
        'caption',
        'images',
        'videos',
        'user_id',
        'music_track_id',
        'music_start_time',
        'music_end_time',
        'status',
        'is_featured',
        'allow_comments',
    ];

    protected $casts = [
        'images' => 'array',
        'videos' => 'array',
        'is_featured' => 'boolean',
        'allow_comments' => 'boolean',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function musicTrack()
    {
        return $this->belongsTo(MusicTrack::class);
    }

    public function likes()
    {
        return $this->hasMany(PostLike::class);
    }

    public function comments()
    {
        return $this->hasMany(PostComment::class);
    }
}
