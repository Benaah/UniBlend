<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class BehindTheScenes extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'title',
        'artist_name',
        'description',
        'thumbnail_url',
        'media_urls',
        'media_type',
        'published_at',
        'is_local',
        'is_featured',
        'view_count',
        'status',
        'location',
        'studio_name',
        'tags',
        'metadata',
    ];

    protected $casts = [
        'published_at' => 'datetime',
        'is_local' => 'boolean',
        'is_featured' => 'boolean',
        'media_urls' => 'array',
        'tags' => 'array',
        'metadata' => 'array',
    ];

    public function scopePublished($query)
    {
        return $query->where('status', 'published')
                    ->where('published_at', '<=', now());
    }

    public function scopeLocal($query)
    {
        return $query->where('is_local', true);
    }

    public function scopeFeatured($query)
    {
        return $query->where('is_featured', true);
    }

    public function incrementViewCount()
    {
        $this->increment('view_count');
    }
}
