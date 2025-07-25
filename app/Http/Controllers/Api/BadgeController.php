<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Badge;
use App\Models\User;
use App\Services\BadgeService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class BadgeController extends Controller
{
    public function __construct(private BadgeService $badgeService)
    {
    }

    public function index(Request $request)
    {
        $query = Badge::where('is_active', true);

        if ($request->has('type')) {
            $query->where('type', $request->type);
        }

        $badges = $query->orderBy('points', 'asc')->get();

        return response()->json([
            'data' => $badges->map(function ($badge) {
                return [
                    'id' => $badge->id,
                    'name' => $badge->name,
                    'description' => $badge->description,
                    'icon' => $badge->icon,
                    'type' => $badge->type,
                    'points' => $badge->points,
                ];
            })
        ]);
    }

    public function userBadges(Request $request)
    {
        $user = Auth::user();
        
        $badges = $user->badges()
            ->orderBy('user_badges.earned_at', 'desc')
            ->get();

        return response()->json([
            'data' => $badges->map(function ($badge) {
                return [
                    'id' => $badge->id,
                    'name' => $badge->name,
                    'description' => $badge->description,
                    'icon' => $badge->icon,
                    'type' => $badge->type,
                    'points' => $badge->points,
                    'earned_at' => $badge->pivot->earned_at,
                ];
            }),
            'total_points' => $user->total_points,
            'total_badges' => $badges->count(),
        ]);
    }

    public function leaderboard(Request $request)
    {
        $period = $request->get('period', 'all_time');
        $limit = min($request->get('limit', 10), 50);

        $leaderboard = $this->badgeService->getLeaderboard($period, $limit);

        return response()->json([
            'data' => collect($leaderboard)->map(function ($user, $index) {
                return [
                    'rank' => $index + 1,
                    'id' => $user['id'],
                    'name' => $user['name'],
                    'total_points' => $user['total_points'],
                    'profile_music_track_id' => $user['profile_music_track_id'],
                ];
            }),
            'period' => $period,
        ]);
    }

    public function userProgress(Request $request)
    {
        $user = Auth::user();
        
        $totalBadges = Badge::where('is_active', true)->count();
        $earnedBadges = $user->badges()->count();
        
        // Get next achievable badges
        $allBadges = Badge::where('is_active', true)->get();
        $nextBadges = [];
        
        foreach ($allBadges as $badge) {
            if (!$user->hasBadge($badge->id)) {
                $progress = $this->calculateBadgeProgress($user, $badge);
                if ($progress['percentage'] > 0) {
                    $nextBadges[] = [
                        'badge' => [
                            'id' => $badge->id,
                            'name' => $badge->name,
                            'description' => $badge->description,
                            'icon' => $badge->icon,
                            'points' => $badge->points,
                        ],
                        'progress' => $progress,
                    ];
                }
            }
        }

        // Sort by progress percentage
        usort($nextBadges, function ($a, $b) {
            return $b['progress']['percentage'] <=> $a['progress']['percentage'];
        });

        return response()->json([
            'total_points' => $user->total_points,
            'total_badges' => $earnedBadges,
            'total_available_badges' => $totalBadges,
            'completion_percentage' => round(($earnedBadges / $totalBadges) * 100, 1),
            'next_badges' => array_slice($nextBadges, 0, 5),
        ]);
    }

    private function calculateBadgeProgress(User $user, Badge $badge): array
    {
        $criteria = $badge->criteria;
        $current = 0;
        $target = 1;
        
        switch ($badge->type) {
            case 'milestone':
                switch ($criteria['type'] ?? '') {
                    case 'total_posts':
                        $current = $user->posts()->count();
                        $target = $criteria['count'];
                        break;
                    case 'total_threads':
                        $current = $user->threads()->count();
                        $target = $criteria['count'];
                        break;
                    case 'total_points':
                        $current = $user->total_points ?? 0;
                        $target = $criteria['points'];
                        break;
                }
                break;
            case 'achievement':
                switch ($criteria['action'] ?? '') {
                    case 'wallet_milestone':
                        $current = $user->wallet?->balance ?? 0;
                        $target = $criteria['amount'];
                        break;
                }
                break;
        }

        $percentage = $target > 0 ? min(100, round(($current / $target) * 100, 1)) : 0;

        return [
            'current' => $current,
            'target' => $target,
            'percentage' => $percentage,
        ];
    }
}
