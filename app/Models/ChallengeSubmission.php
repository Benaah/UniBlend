<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class ChallengeSubmission extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'music_challenge_id',
        'user_id',
        'title',
        'description',
        'media_url',
        'media_type',
        'thumbnail_url',
        'duration',
        'status',
        'submission_date',
        'votes_count',
        'admin_score',
        'is_winner',
        'social_media_links',
        'metadata',
    ];

    protected $casts = [
        'submission_date' => 'datetime',
        'is_winner' => 'boolean',
        'social_media_links' => 'array',
        'metadata' => 'array',
    ];

    public function challenge()
    {
        return $this->belongsTo(MusicChallenge::class, 'music_challenge_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function votes()
    {
        return $this->hasMany(SubmissionVote::class);
    }

    public function scopeApproved($query)
    {
        return $query->where('status', 'approved');
    }

    public function scopePending($query)
    {
        return $query->where('status', 'pending');
    }

    public function scopeWinners($query)
    {
        return $query->where('is_winner', true);
    }

    public function incrementVoteCount()
    {
        $this->increment('votes_count');
    }

    public function decrementVoteCount()
    {
        $this->decrement('votes_count');
    }

    public function getDurationFormattedAttribute()
    {
        if (!$this->duration) return '';
        $minutes = floor($this->duration / 60);
        $seconds = $this->duration % 60;
        return sprintf('%d:%02d', $minutes, $seconds);
    }
}
