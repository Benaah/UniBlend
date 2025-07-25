# UniBlend Laravel Project - Agent Guide

## Commands
- **Build**: `npm run build` (Vite build), `php artisan config:cache` (Laravel optimization)
- **Dev**: `composer run dev` (starts server, queue, and Vite concurrently) or `php artisan serve`
- **Test**: `php artisan test` (all tests), `php artisan test --filter=TestName` (single test)
- **Lint/Format**: `./vendor/bin/pint` (Laravel Pint for PHP), `npm run dev` (Vite for assets)
- **Queue**: `php artisan queue:work`

## Architecture
- **Laravel 12** with **Livewire/Volt**, **Filament Admin Panel**, **Sanctum API**
- **Frontend**: Vite + TailwindCSS v4, Livewire components, Flux UI
- **Database**: SQLite (default), configured in `config/database.php`
- **Testing**: Pest PHP for unit/feature tests in `tests/` directory
- **Key Models**: User, Profile, Thread, Post, Booking, Notification, Wallet (forum/booking system)

## Code Style
- **PSR-4** autoloading: `App\`, `Database\Factories\`, `Database\Seeders\`, `Tests\`
- **EditorConfig**: 4 spaces, UTF-8, LF endings, final newlines
- **PHP**: StudlyCase classes, camelCase methods, snake_case DB fields, Laravel Pint formatting
- **Imports**: Group by vendor, Laravel, then App namespace
- **Conventions**: Laravel standards, Eloquent relationships, Livewire component patterns
