<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Club extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'description',
    ];

    public function threads()
    {
        return $this->hasMany(Thread::class);
    }

    public function members()
    {
        return $this->belongsToMany(User::class, 'club_user', 'club_id', 'user_id');
    }
}
