<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\MusicChallenge;
use App\Models\ChallengeSubmission;
use App\Models\SubmissionVote;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\Rule;

class MusicChallengeController extends Controller
{
    public function index(Request $request)
    {
        $query = MusicChallenge::query();

        if ($request->has('active')) {
            $query->active();
        }

        if ($request->has('featured')) {
            $query->featured();
        }

        if ($request->has('category')) {
            $query->where('category', $request->category);
        }

        $challenges = $query->orderBy('end_date', 'asc')->paginate(20);

        // Add computed attributes
        $challenges->getCollection()->transform(function ($challenge) {
            return $challenge->append(['days_left', 'time_left_text', 'prize_money_formatted', 'participants_count']);
        });

        return response()->json([
            'data' => $challenges->items(),
            'pagination' => [
                'current_page' => $challenges->currentPage(),
                'last_page' => $challenges->lastPage(),
                'per_page' => $challenges->perPage(),
                'total' => $challenges->total(),
            ]
        ]);
    }

    public function show($id)
    {
        $challenge = MusicChallenge::findOrFail($id);
        
        return response()->json([
            'data' => $challenge->append(['days_left', 'time_left_text', 'prize_money_formatted', 'participants_count'])
        ]);
    }

    public function getSubmissions(Request $request, $challengeId)
    {
        $challenge = MusicChallenge::findOrFail($challengeId);
        
        $query = ChallengeSubmission::where('music_challenge_id', $challengeId)
            ->approved()
            ->with('user');

        if ($request->has('sort')) {
            switch ($request->sort) {
                case 'popular':
                    $query->orderBy('votes_count', 'desc');
                    break;
                case 'recent':
                    $query->orderBy('submission_date', 'desc');
                    break;
                case 'admin_choice':
                    $query->orderBy('admin_score', 'desc');
                    break;
                default:
                    $query->orderBy('submission_date', 'desc');
            }
        } else {
            $query->orderBy('submission_date', 'desc');
        }

        $submissions = $query->paginate(20);

        return response()->json([
            'data' => $submissions->items(),
            'pagination' => [
                'current_page' => $submissions->currentPage(),
                'last_page' => $submissions->lastPage(),
                'per_page' => $submissions->perPage(),
                'total' => $submissions->total(),
            ]
        ]);
    }

    public function submitEntry(Request $request, $challengeId)
    {
        $challenge = MusicChallenge::findOrFail($challengeId);
        
        if (!$challenge->canParticipate()) {
            return response()->json([
                'message' => 'This challenge is no longer accepting submissions.'
            ], 422);
        }

        // Check if user already submitted
        $existingSubmission = ChallengeSubmission::where('music_challenge_id', $challengeId)
            ->where('user_id', Auth::id())
            ->first();

        if ($existingSubmission) {
            return response()->json([
                'message' => 'You have already submitted an entry for this challenge.'
            ], 422);
        }

        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string|max:1000',
            'media_file' => 'required|file|mimes:mp4,mov,avi,mp3,wav,jpg,jpeg,png|max:50000', // 50MB max
            'media_type' => ['required', Rule::in(['video', 'audio', 'image'])],
            'social_media_links' => 'nullable|array',
            'social_media_links.*' => 'url',
        ]);

        // Upload media file
        $mediaPath = $request->file('media_file')->store('challenge-submissions', 'public');
        $mediaUrl = Storage::url($mediaPath);

        // Generate thumbnail for videos (simplified - in real app would use FFmpeg)
        $thumbnailUrl = null;
        if ($validated['media_type'] === 'video') {
            // TODO: Generate video thumbnail
            $thumbnailUrl = $mediaUrl; // Placeholder
        } elseif ($validated['media_type'] === 'image') {
            $thumbnailUrl = $mediaUrl;
        }

        $submission = ChallengeSubmission::create([
            'music_challenge_id' => $challengeId,
            'user_id' => Auth::id(),
            'title' => $validated['title'],
            'description' => $validated['description'],
            'media_url' => $mediaUrl,
            'media_type' => $validated['media_type'],
            'thumbnail_url' => $thumbnailUrl,
            'social_media_links' => $validated['social_media_links'] ?? [],
            'submission_date' => now(),
        ]);

        return response()->json([
            'message' => 'Your submission has been uploaded successfully!',
            'data' => $submission
        ], 201);
    }

    public function voteSubmission(Request $request, $submissionId)
    {
        $submission = ChallengeSubmission::findOrFail($submissionId);
        
        $validated = $request->validate([
            'vote_type' => ['required', Rule::in(['up', 'down'])],
        ]);

        // Check if user already voted
        $existingVote = SubmissionVote::where('challenge_submission_id', $submissionId)
            ->where('user_id', Auth::id())
            ->first();

        if ($existingVote) {
            if ($existingVote->vote_type === $validated['vote_type']) {
                // Remove vote
                $existingVote->delete();
                if ($validated['vote_type'] === 'up') {
                    $submission->decrementVoteCount();
                }
                $message = 'Vote removed';
            } else {
                // Change vote
                $existingVote->update(['vote_type' => $validated['vote_type']]);
                if ($validated['vote_type'] === 'up') {
                    $submission->incrementVoteCount();
                } else {
                    $submission->decrementVoteCount();
                }
                $message = 'Vote updated';
            }
        } else {
            // New vote
            SubmissionVote::create([
                'challenge_submission_id' => $submissionId,
                'user_id' => Auth::id(),
                'vote_type' => $validated['vote_type'],
            ]);
            
            if ($validated['vote_type'] === 'up') {
                $submission->incrementVoteCount();
            }
            $message = 'Vote recorded';
        }

        return response()->json([
            'message' => $message,
            'votes_count' => $submission->fresh()->votes_count
        ]);
    }

    public function getUserSubmission($challengeId)
    {
        $submission = ChallengeSubmission::where('music_challenge_id', $challengeId)
            ->where('user_id', Auth::id())
            ->first();

        if (!$submission) {
            return response()->json([
                'data' => null
            ]);
        }

        return response()->json([
            'data' => $submission
        ]);
    }

    public function getWinners($challengeId)
    {
        $challenge = MusicChallenge::findOrFail($challengeId);
        
        $winners = ChallengeSubmission::where('music_challenge_id', $challengeId)
            ->where('is_winner', true)
            ->with('user')
            ->orderBy('admin_score', 'desc')
            ->get();

        return response()->json([
            'data' => $winners
        ]);
    }

    public function getCategories()
    {
        $categories = [
            'dance' => 'Dance Challenge',
            'cover' => 'Cover Song',
            'original' => 'Original Composition',
            'remix' => 'Remix Challenge',
            'acapella' => 'Acapella',
            'instrumental' => 'Instrumental',
            'freestyle' => 'Freestyle',
            'collaboration' => 'Collaboration',
        ];

        return response()->json([
            'data' => $categories
        ]);
    }

    public function suggestChallenge(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'required|string|max:1000',
            'category' => 'required|string',
            'suggested_prize' => 'nullable|numeric|min:0',
            'suggested_duration' => 'nullable|integer|min:1|max:90', // days
        ]);

        // In a real app, this would save to a suggestions table
        // For now, we'll just return a success message
        
        return response()->json([
            'message' => 'Thank you for your suggestion! We\'ll review it and may feature it in upcoming challenges.'
        ]);
    }
}
