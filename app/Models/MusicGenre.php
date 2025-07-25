<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class MusicGenre extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'description',
        'cover_image',
        'is_local',
        'is_featured',
        'sort_order',
    ];

    protected $casts = [
        'is_local' => 'boolean',
        'is_featured' => 'boolean',
    ];

    public function tracks()
    {
        return $this->hasMany(MusicTrack::class, 'genre', 'name');
    }

    public function scopeLocal($query)
    {
        return $query->where('is_local', true);
    }

    public function scopeFeatured($query)
    {
        return $query->where('is_featured', true);
    }
}
