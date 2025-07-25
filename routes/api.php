<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\FlashClassController;
use App\Http\Controllers\ThreadController;
use App\Http\Controllers\PostController;
use App\Http\Controllers\ServiceController;
use App\Http\Controllers\BookingController;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\WalletController;
use App\Http\Controllers\Api\BadgeController;

// Authentication Routes with rate limiting
Route::middleware('throttle:5,1')->group(function () {
    Route::post('register', [AuthController::class, 'register']);
    Route::post('login', [AuthController::class, 'login']);
});
Route::middleware('auth:sanctum')->post('logout', [AuthController::class, 'logout']);

// User Routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('user', [UserController::class, 'show']);
    Route::put('user', [UserController::class, 'update']);
});

// Profile Routes
Route::middleware('auth:sanctum')->apiResource('profiles', ProfileController::class);

// FlashClass Routes
Route::middleware('auth:sanctum')->apiResource('flash-classes', FlashClassController::class);

// Thread Routes
Route::middleware('auth:sanctum')->apiResource('threads', ThreadController::class);

// Post Routes
Route::middleware('auth:sanctum')->apiResource('posts', PostController::class);

// Service Routes
Route::middleware('auth:sanctum')->get('services', [ServiceController::class, 'index']);

// Booking Routes
Route::middleware('auth:sanctum')->apiResource('bookings', BookingController::class);

// Notification Routes
Route::middleware('auth:sanctum')->get('notifications', [NotificationController::class, 'index']);
Route::middleware('auth:sanctum')->post('notifications/mark-read', [NotificationController::class, 'markRead']);

// Wallet Routes
Route::middleware('auth:sanctum')->get('wallet', [WalletController::class, 'show']);
Route::middleware('auth:sanctum')->post('wallet/deposit', [WalletController::class, 'deposit']);
Route::middleware('auth:sanctum')->post('wallet/withdraw', [WalletController::class, 'withdraw']);

// Gamification Routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('badges', [BadgeController::class, 'index']);
    Route::get('badges/my-badges', [BadgeController::class, 'userBadges']);
    Route::get('badges/leaderboard', [BadgeController::class, 'leaderboard']);
    Route::get('badges/progress', [BadgeController::class, 'userProgress']);
});
