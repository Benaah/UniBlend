<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class MusicChallenge extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'title',
        'description',
        'hashtag',
        'prize_money',
        'prize_description',
        'start_date',
        'end_date',
        'is_active',
        'is_featured',
        'rules',
        'submission_guidelines',
        'sponsor',
        'banner_image',
        'category',
        'difficulty_level',
        'max_participants',
        'metadata',
    ];

    protected $casts = [
        'start_date' => 'datetime',
        'end_date' => 'datetime',
        'is_active' => 'boolean',
        'is_featured' => 'boolean',
        'rules' => 'array',
        'submission_guidelines' => 'array',
        'metadata' => 'array',
    ];

    public function submissions()
    {
        return $this->hasMany(ChallengeSubmission::class);
    }

    public function scopeActive($query)
    {
        return $query->where('is_active', true)
                    ->where('start_date', '<=', now())
                    ->where('end_date', '>=', now());
    }

    public function scopeFeatured($query)
    {
        return $query->where('is_featured', true);
    }

    public function getDaysLeftAttribute()
    {
        if ($this->end_date->isPast()) return 0;
        return $this->end_date->diffInDays(now());
    }

    public function getTimeLeftTextAttribute()
    {
        $days = $this->days_left;
        if ($days > 0) return "$days days left";
        return "Ending soon";
    }

    public function getPrizeMoneyFormattedAttribute()
    {
        return 'KSh ' . number_format($this->prize_money, 0);
    }

    public function getParticipantsCountAttribute()
    {
        return $this->submissions()->distinct('user_id')->count('user_id');
    }

    public function isExpired()
    {
        return $this->end_date->isPast();
    }

    public function canParticipate()
    {
        return $this->is_active && 
               !$this->isExpired() && 
               ($this->max_participants === null || $this->participants_count < $this->max_participants);
    }
}
