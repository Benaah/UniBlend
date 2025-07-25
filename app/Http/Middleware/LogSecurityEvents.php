<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Symfony\Component\HttpFoundation\Response;

class LogSecurityEvents
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        $response = $next($request);

        // Log suspicious activity
        if ($this->isSuspiciousActivity($request, $response)) {
            Log::channel('security')->warning('Suspicious activity detected', [
                'ip' => $request->ip(),
                'user_agent' => $request->userAgent(),
                'method' => $request->method(),
                'url' => $request->fullUrl(),
                'status_code' => $response->getStatusCode(),
                'user_id' => Auth::check() ? Auth::id() : null,
                'timestamp' => now()->toISOString(),
            ]);
        }

        // Log authentication events
        if ($this->isAuthenticationRoute($request)) {
            Log::channel('security')->info('Authentication attempt', [
                'ip' => $request->ip(),
                'email' => $request->input('email'),
                'route' => $request->route()?->getName(),
                'status_code' => $response->getStatusCode(),
                'timestamp' => now()->toISOString(),
            ]);
        }

        return $response;
    }

    private function isSuspiciousActivity(Request $request, Response $response): bool
    {
        return $response->getStatusCode() === 401 ||
               $response->getStatusCode() === 403 ||
               $response->getStatusCode() === 419 || // CSRF token mismatch
               str_contains($request->fullUrl(), 'admin') ||
               str_contains($request->userAgent() ?? '', 'bot');
    }

    private function isAuthenticationRoute(Request $request): bool
    {
        $authRoutes = ['login', 'register', 'logout', 'password.reset'];
        $routeName = $request->route()?->getName();
        
        return in_array($routeName, $authRoutes) ||
               str_contains($request->path(), 'auth') ||
               str_contains($request->path(), 'login') ||
               str_contains($request->path(), 'register');
    }
}
