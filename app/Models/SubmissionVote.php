<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SubmissionVote extends Model
{
    use HasFactory;

    protected $fillable = [
        'challenge_submission_id',
        'user_id',
        'vote_type',
    ];

    public function submission()
    {
        return $this->belongsTo(ChallengeSubmission::class, 'challenge_submission_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
