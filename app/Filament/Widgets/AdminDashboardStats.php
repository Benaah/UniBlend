<?php

namespace App\Filament\Widgets;

use App\Models\User;
use App\Models\Thread;
use App\Models\Post;
use App\Models\FlashClass;
use App\Models\Booking;
use App\Models\Wallet;
use App\Models\MusicTrack;
use App\Models\Playlist;
use App\Models\Notification;
use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class AdminDashboardStats extends BaseWidget
{
    protected function getStats(): array
    {
        return [
            Stat::make('Total Users', User::count())
                ->description('Registered users')
                ->descriptionIcon('heroicon-m-users')
                ->color('success'),

            Stat::make('New Users Today', User::whereDate('created_at', today())->count())
                ->description('Users registered today')
                ->descriptionIcon('heroicon-m-user-plus')
                ->color('info'),

            Stat::make('Active Threads', Thread::count())
                ->description('Forum discussions')
                ->descriptionIcon('heroicon-m-chat-bubble-left-right')
                ->color('primary'),

            Stat::make('Total Posts', Post::count())
                ->description('Forum posts')
                ->descriptionIcon('heroicon-m-document-text')
                ->color('warning'),

            Stat::make('Flash Classes', FlashClass::count())
                ->description('Available classes')
                ->descriptionIcon('heroicon-m-academic-cap')
                ->color('success'),

            Stat::make('Total Bookings', Booking::count())
                ->description('Service bookings')
                ->descriptionIcon('heroicon-m-calendar-days')
                ->color('info'),

            Stat::make('Total Wallet Balance', '₦' . number_format(Wallet::sum('balance'), 2))
                ->description('System wallet total')
                ->descriptionIcon('heroicon-m-banknotes')
                ->color('primary'),

            Stat::make('Pending Bookings', Booking::where('status', 'pending')->count())
                ->description('Awaiting confirmation')
                ->descriptionIcon('heroicon-m-clock')
                ->color('warning'),

            Stat::make('Music Tracks', MusicTrack::count())
                ->description('Total music tracks')
                ->descriptionIcon('heroicon-m-musical-note')
                ->color('info'),

            Stat::make('Active Playlists', Playlist::where('status', 'active')->count())
                ->description('Public playlists')
                ->descriptionIcon('heroicon-m-queue-list')
                ->color('success'),

            Stat::make('Unread Notifications', Notification::where('read_status', false)->count())
                ->description('Pending notifications')
                ->descriptionIcon('heroicon-m-bell')
                ->color('warning'),
        ];
    }
}
