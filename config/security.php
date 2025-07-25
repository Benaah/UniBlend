<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Security Configuration
    |--------------------------------------------------------------------------
    |
    | This file contains the security configuration for your application.
    | You can modify these settings based on your security requirements.
    |
    */

    'password_timeout' => env('PASSWORD_TIMEOUT', 10800), // 3 hours

    'session_timeout' => env('SESSION_TIMEOUT', 7200), // 2 hours

    'max_login_attempts' => env('MAX_LOGIN_ATTEMPTS', 5),

    'lockout_duration' => env('LOCKOUT_DURATION', 900), // 15 minutes

    'two_factor_enabled' => env('TWO_FACTOR_ENABLED', false),

    'enforce_https' => env('ENFORCE_HTTPS', true),

    'hsts_max_age' => env('HSTS_MAX_AGE', 31536000), // 1 year

    'content_security_policy' => [
        'default_src' => "'self'",
        'script_src' => "'self' 'unsafe-inline' 'unsafe-eval' https://js.pusher.com",
        'style_src' => "'self' 'unsafe-inline' https://fonts.googleapis.com",
        'font_src' => "'self' https://fonts.gstatic.com",
        'img_src' => "'self' data: https:",
        'connect_src' => "'self' wss: https:",
        'frame_ancestors' => "'none'",
    ],

    'file_upload' => [
        'max_size' => env('MAX_FILE_SIZE', 5120), // 5MB in KB
        'allowed_extensions' => ['jpg', 'jpeg', 'png', 'gif', 'pdf', 'doc', 'docx'],
        'allowed_mimes' => [
            'image/jpeg', 'image/png', 'image/gif',
            'application/pdf',
            'application/msword',
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
        ],
    ],
];
