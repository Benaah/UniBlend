<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\User;
use App\Models\Course;
use App\Models\Club;

class Thread extends Model
{
    use HasFactory;

    protected $fillable = [
        'title',
        'content',
        'author_id',
        'course_id',
        'club_id',
        'music_track_id',
        'category',
        'status',
        'is_pinned',
        'is_music_related',
    ];

    public function author()
    {
        return $this->belongsTo(User::class, 'author_id');
    }

    public function course()
    {
        return $this->belongsTo(Course::class);
    }

    public function club()
    {
        return $this->belongsTo(Club::class);
    }

    public function musicTrack()
    {
        return $this->belongsTo(MusicTrack::class);
    }

    public function posts()
    {
        return $this->hasMany(ThreadPost::class);
    }

    protected $casts = [
        'is_pinned' => 'boolean',
        'is_music_related' => 'boolean',
    ];
}
