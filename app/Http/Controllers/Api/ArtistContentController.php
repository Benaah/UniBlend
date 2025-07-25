<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ArtistInterview;
use App\Models\BehindTheScenes;
use Illuminate\Http\Request;

class ArtistContentController extends Controller
{
    public function getInterviews(Request $request)
    {
        $query = ArtistInterview::published()
            ->orderBy('published_at', 'desc');

        if ($request->has('featured')) {
            $query->featured();
        }

        if ($request->has('local')) {
            $query->local();
        }

        if ($request->has('artist')) {
            $query->where('artist_name', 'like', '%' . $request->artist . '%');
        }

        $interviews = $query->paginate(20);

        return response()->json([
            'data' => $interviews->items(),
            'pagination' => [
                'current_page' => $interviews->currentPage(),
                'last_page' => $interviews->lastPage(),
                'per_page' => $interviews->perPage(),
                'total' => $interviews->total(),
            ]
        ]);
    }

    public function getInterview($id)
    {
        $interview = ArtistInterview::published()->findOrFail($id);
        
        // Increment view count
        $interview->incrementViewCount();

        return response()->json([
            'data' => $interview
        ]);
    }

    public function getBehindTheScenes(Request $request)
    {
        $query = BehindTheScenes::published()
            ->orderBy('published_at', 'desc');

        if ($request->has('featured')) {
            $query->featured();
        }

        if ($request->has('local')) {
            $query->local();
        }

        if ($request->has('artist')) {
            $query->where('artist_name', 'like', '%' . $request->artist . '%');
        }

        $content = $query->paginate(20);

        return response()->json([
            'data' => $content->items(),
            'pagination' => [
                'current_page' => $content->currentPage(),
                'last_page' => $content->lastPage(),
                'per_page' => $content->perPage(),
                'total' => $content->total(),
            ]
        ]);
    }

    public function getBehindTheScenesItem($id)
    {
        $content = BehindTheScenes::published()->findOrFail($id);
        
        // Increment view count
        $content->incrementViewCount();

        return response()->json([
            'data' => $content
        ]);
    }

    public function getMusicNews(Request $request)
    {
        // Mock music news data - in real implementation, this would come from a news model
        $news = [
            [
                'id' => 1,
                'title' => 'Kenyan Music Week 2024 Announced',
                'summary' => 'The biggest celebration of Kenyan music returns this December with over 100 local artists',
                'content' => 'Kenyan Music Week 2024 has been officially announced...',
                'category' => 'Events',
                'author' => 'UniBlend Editorial',
                'published_at' => now()->subHours(2)->toISOString(),
                'image_url' => null,
                'is_featured' => true,
            ],
            [
                'id' => 2,
                'title' => 'Benga Revival Movement Gains Momentum',
                'summary' => 'Young artists are bringing traditional Benga music to the modern generation',
                'content' => 'The Benga revival movement is gaining significant momentum...',
                'category' => 'Trends',
                'author' => 'Music Kenya',
                'published_at' => now()->subDay()->toISOString(),
                'image_url' => null,
                'is_featured' => false,
            ],
            [
                'id' => 3,
                'title' => 'New Recording Studio Opens in Nairobi',
                'summary' => 'State-of-the-art facility aims to support emerging Kenyan artists',
                'content' => 'A new world-class recording studio has opened its doors in Nairobi...',
                'category' => 'Industry',
                'author' => 'Studio News',
                'published_at' => now()->subDays(3)->toISOString(),
                'image_url' => null,
                'is_featured' => false,
            ],
        ];

        return response()->json([
            'data' => $news
        ]);
    }

    public function getFeaturedContent()
    {
        $featuredInterviews = ArtistInterview::published()
            ->featured()
            ->limit(5)
            ->get();

        $featuredBehindScenes = BehindTheScenes::published()
            ->featured()
            ->limit(5)
            ->get();

        return response()->json([
            'data' => [
                'interviews' => $featuredInterviews,
                'behind_the_scenes' => $featuredBehindScenes,
            ]
        ]);
    }

    public function searchContent(Request $request)
    {
        $query = $request->get('q', '');
        
        if (empty($query)) {
            return response()->json([
                'data' => [
                    'interviews' => [],
                    'behind_the_scenes' => [],
                ]
            ]);
        }

        $interviews = ArtistInterview::published()
            ->where(function($q) use ($query) {
                $q->where('title', 'like', "%{$query}%")
                  ->orWhere('artist_name', 'like', "%{$query}%")
                  ->orWhere('description', 'like', "%{$query}%");
            })
            ->limit(10)
            ->get();

        $behindScenes = BehindTheScenes::published()
            ->where(function($q) use ($query) {
                $q->where('title', 'like', "%{$query}%")
                  ->orWhere('artist_name', 'like', "%{$query}%")
                  ->orWhere('description', 'like', "%{$query}%");
            })
            ->limit(10)
            ->get();

        return response()->json([
            'data' => [
                'interviews' => $interviews,
                'behind_the_scenes' => $behindScenes,
            ]
        ]);
    }
}
