<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use App\Models\Profile;
use App\Models\Thread;
use App\Models\Post;
use App\Models\Booking;
use App\Models\Notification;
use App\Models\Wallet;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;


    protected $fillable = [
        'name',
        'email',
        'password',
        'role',
        'provider_name',
        'provider_id',
        'mpesa_id',
        'kcpe_id',
        'phone',
        'phone_verified_at',
        'profile_music_track_id',
        'favorite_genres',
        'music_preferences',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
        'favorite_genres' => 'array',
        'music_preferences' => 'array',
    ];

    public function profile()
    {
        return $this->hasOne(Profile::class);
    }

    public function threads()
    {
        return $this->hasMany(Thread::class, 'author_id');
    }

    public function posts()
    {
        return $this->hasMany(Post::class);
    }

    public function bookings()
    {
        return $this->hasMany(Booking::class);
    }

    public function notifications()
    {
        return $this->hasMany(Notification::class);
    }

    public function wallet()
    {
        return $this->hasOne(Wallet::class);
    }

    public function profileMusicTrack()
    {
        return $this->belongsTo(MusicTrack::class, 'profile_music_track_id');
    }

    public function playlists()
    {
        return $this->hasMany(Playlist::class);
    }

    public function favoriteTracks()
    {
        return $this->belongsToMany(MusicTrack::class, 'user_favorite_tracks')->withTimestamps();
    }

    public function followedPlaylists()
    {
        return $this->belongsToMany(Playlist::class, 'playlist_followers')->withTimestamps();
    }

    public function badges()
    {
        return $this->belongsToMany(Badge::class, 'user_badges')->withTimestamps()->withPivot('earned_at');
    }

    public function userBadges()
    {
        return $this->hasMany(UserBadge::class);
    }

    public function getTotalPointsAttribute()
    {
        return $this->badges()->sum('points');
    }

    public function hasBadge($badgeId)
    {
        return $this->badges()->where('badge_id', $badgeId)->exists();
    }
}
