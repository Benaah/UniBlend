<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\Thread;
use App\Models\FlashClass;

class Course extends Model
{
    use HasFactory;

    protected $fillable = [
        'course_code',
        'name',
        'description',
    ];

    public function threads()
    {
        return $this->hasMany(Thread::class);
    }

    public function flashClasses()
    {
        return $this->hasMany(FlashClass::class);
    }
}
