<?php

namespace Database\Seeders;

use App\Models\Badge;
use Illuminate\Database\Seeder;

class BadgeSeeder extends Seeder
{
    public function run(): void
    {
        $badges = [
            [
                'name' => 'First Post',
                'description' => 'Created your first post',
                'icon' => '📝',
                'type' => 'engagement',
                'criteria' => ['action' => 'post_created', 'count' => 1],
                'points' => 10,
            ],
            [
                'name' => 'Thread Starter',
                'description' => 'Started your first discussion thread',
                'icon' => '💬',
                'type' => 'engagement',
                'criteria' => ['action' => 'thread_created', 'count' => 1],
                'points' => 15,
            ],
            [
                'name' => 'Music Champion',
                'description' => 'Won your first music challenge',
                'icon' => '🏆',
                'type' => 'achievement',
                'criteria' => ['action' => 'challenge_won', 'count' => 1],
                'points' => 50,
            ],
            [
                'name' => 'Content Creator',
                'description' => 'Created 10 posts',
                'icon' => '🎨',
                'type' => 'milestone',
                'criteria' => ['type' => 'total_posts', 'count' => 10],
                'points' => 25,
            ],
            [
                'name' => 'Discussion Leader',
                'description' => 'Started 5 discussion threads',
                'icon' => '👑',
                'type' => 'milestone',
                'criteria' => ['type' => 'total_threads', 'count' => 5],
                'points' => 30,
            ],
            [
                'name' => 'Rising Star',
                'description' => 'Earned 100 total points',
                'icon' => '⭐',
                'type' => 'milestone',
                'criteria' => ['type' => 'total_points', 'points' => 100],
                'points' => 20,
            ],
            [
                'name' => 'Money Maker',
                'description' => 'Reached 1000 KSh in wallet',
                'icon' => '💰',
                'type' => 'achievement',
                'criteria' => ['action' => 'wallet_milestone', 'amount' => 1000],
                'points' => 40,
            ],
            [
                'name' => 'Daily Streaker',
                'description' => 'Used the app for 7 consecutive days',
                'icon' => '🔥',
                'type' => 'achievement',
                'criteria' => ['action' => 'music_streak', 'days' => 7],
                'points' => 35,
            ],
            [
                'name' => 'Super Contributor',
                'description' => 'Created 50 posts',
                'icon' => '🌟',
                'type' => 'milestone',
                'criteria' => ['type' => 'total_posts', 'count' => 50],
                'points' => 75,
            ],
            [
                'name' => 'Community Builder',
                'description' => 'Started 20 discussion threads',
                'icon' => '🏗️',
                'type' => 'milestone',
                'criteria' => ['type' => 'total_threads', 'count' => 20],
                'points' => 100,
            ],
        ];

        foreach ($badges as $badge) {
            Badge::create($badge);
        }
    }
}
