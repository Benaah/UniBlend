<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Routing\Middleware\ThrottleRequests;

class ApiRateLimitMiddleware extends ThrottleRequests
{
    protected function resolveRequestSignature($request)
    {
        return $request->user() ? $request->user()->id : $request->ip();
    }

    public function handle($request, Closure $next, $maxAttempts = 60, $decayMinutes = 1, $prefix = '')
    {
        return parent::handle($request, $next, $maxAttempts, $decayMinutes, $prefix);
    }
}
