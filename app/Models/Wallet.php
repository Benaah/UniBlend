<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Wallet extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'balance',
        'transaction_history',
    ];

    protected $casts = [
        'transaction_history' => 'array',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
