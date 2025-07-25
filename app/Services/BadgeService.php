<?php

namespace App\Services;

use App\Models\Badge;
use App\Models\User;
use App\Models\UserBadge;

class BadgeService
{
    public function checkAndAwardBadges(User $user, string $action, array $data = [])
    {
        $badges = Badge::where('is_active', true)->get();
        $newBadges = [];

        foreach ($badges as $badge) {
            if (!$user->hasBadge($badge->id) && $this->meetsCriteria($user, $badge, $action, $data)) {
                $this->awardBadge($user, $badge);
                $newBadges[] = $badge;
            }
        }

        return $newBadges;
    }

    private function meetsCriteria(User $user, Badge $badge, string $action, array $data): bool
    {
        $criteria = $badge->criteria;

        switch ($badge->type) {
            case 'engagement':
                return $this->checkEngagementCriteria($user, $criteria, $action);
            case 'achievement':
                return $this->checkAchievementCriteria($user, $criteria, $action, $data);
            case 'milestone':
                return $this->checkMilestoneCriteria($user, $criteria);
            default:
                return false;
        }
    }

    private function checkEngagementCriteria(User $user, array $criteria, string $action): bool
    {
        if (!isset($criteria['action']) || $criteria['action'] !== $action) {
            return false;
        }

        switch ($action) {
            case 'post_created':
                return $user->posts()->count() >= ($criteria['count'] ?? 1);
            case 'thread_created':
                return $user->threads()->count() >= ($criteria['count'] ?? 1);
            case 'challenge_won':
                return $user->challengeSubmissions()->where('is_winner', true)->count() >= ($criteria['count'] ?? 1);
            default:
                return false;
        }
    }

    private function checkAchievementCriteria(User $user, array $criteria, string $action, array $data): bool
    {
        if (!isset($criteria['action']) || $criteria['action'] !== $action) {
            return false;
        }

        switch ($action) {
            case 'wallet_milestone':
                return $user->wallet?->balance >= ($criteria['amount'] ?? 1000);
            case 'music_streak':
                return isset($data['streak_days']) && $data['streak_days'] >= ($criteria['days'] ?? 7);
            default:
                return false;
        }
    }

    private function checkMilestoneCriteria(User $user, array $criteria): bool
    {
        $totalPosts = $user->posts()->count();
        $totalThreads = $user->threads()->count();
        $totalPoints = $user->total_points ?? 0;

        return match ($criteria['type'] ?? '') {
            'total_posts' => $totalPosts >= ($criteria['count'] ?? 10),
            'total_threads' => $totalThreads >= ($criteria['count'] ?? 5),
            'total_points' => $totalPoints >= ($criteria['points'] ?? 100),
            default => false,
        };
    }

    private function awardBadge(User $user, Badge $badge): void
    {
        UserBadge::create([
            'user_id' => $user->id,
            'badge_id' => $badge->id,
            'earned_at' => now(),
        ]);
    }

    public function getLeaderboard(string $period = 'all_time', int $limit = 10): array
    {
        $query = User::with('badges')
            ->selectRaw('users.*, COALESCE(SUM(badges.points), 0) as total_points')
            ->leftJoin('user_badges', 'users.id', '=', 'user_badges.user_id')
            ->leftJoin('badges', 'user_badges.badge_id', '=', 'badges.id');

        if ($period !== 'all_time') {
            $date = match ($period) {
                'weekly' => now()->subWeek(),
                'monthly' => now()->subMonth(),
                default => now()->subWeek(),
            };
            $query->where('user_badges.earned_at', '>=', $date);
        }

        return $query->groupBy('users.id')
            ->orderByDesc('total_points')
            ->limit($limit)
            ->get()
            ->toArray();
    }
}
