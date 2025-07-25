<?php

namespace App\Http\Controllers;

use App\Models\Profile;
use Illuminate\Http\Request;

class ProfileController extends Controller
{
    public function index()
    {
        return Profile::all();
    }

    public function show(Profile $profile)
    {
        return $profile;
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'user_id' => 'required|exists:users,id',
            'bio' => 'nullable|string',
            'avatar' => 'nullable|string',
            'interests' => 'nullable|array',
        ]);

        $profile = Profile::create($validated);

        return response()->json($profile, 201);
    }

    public function update(Request $request, Profile $profile)
    {
        $validated = $request->validate([
            'bio' => 'nullable|string',
            'avatar' => 'nullable|string',
            'interests' => 'nullable|array',
        ]);

        $profile->update($validated);

        return response()->json($profile);
    }

    public function destroy(Profile $profile)
    {
        $profile->delete();

        return response()->json(null, 204);
    }
}
