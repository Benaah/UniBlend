<?php

use App\Http\Controllers\Auth\VerifyEmailController;
use Illuminate\Support\Facades\Route;
use Livewire\Volt\Volt;

use App\Http\Controllers\AuthController;

Route::middleware('guest')->group(function () {
    Volt::route('login', 'auth.login')
        ->name('login');

    Volt::route('register', 'auth.register')
        ->name('register');

    Volt::route('forgot-password', 'auth.forgot-password')
        ->name('password.request');

    Volt::route('reset-password/{token}', 'auth.reset-password')
        ->name('password.reset');

    // OAuth routes
    Route::get('login/{provider}', [AuthController::class, 'redirectToProvider'])
        ->name('oauth.redirect');

    Route::get('login/{provider}/callback', [AuthController::class, 'handleProviderCallback'])
        ->name('oauth.callback');

    // M-Pesa and KCPE ID login
    Route::post('login/mpesa', [AuthController::class, 'mpesaLogin'])
        ->name('login.mpesa');

    Route::post('login/kcpe', [AuthController::class, 'kcpeLogin'])
        ->name('login.kcpe');
});

Route::middleware('auth')->group(function () {
    Volt::route('verify-email', 'auth.verify-email')
        ->name('verification.notice');

    Route::get('verify-email/{id}/{hash}', VerifyEmailController::class)
        ->middleware(['signed', 'throttle:6,1'])
        ->name('verification.verify');

    Volt::route('confirm-password', 'auth.confirm-password')
        ->name('password.confirm');

    // Email verification resend
    Route::post('email/verification-notification', [AuthController::class, 'resendEmailVerification'])
        ->middleware('throttle:6,1')
        ->name('verification.send');

    // Phone verification
    Route::post('phone/verify', [AuthController::class, 'verifyPhone'])
        ->name('phone.verify');

    // Password reset
    Route::post('password/email', [AuthController::class, 'sendPasswordResetLink'])
        ->name('password.email');

    Route::post('password/reset', [AuthController::class, 'resetPassword'])
        ->name('password.update');
});

Route::post('logout', App\Livewire\Actions\Logout::class)
    ->name('logout');
