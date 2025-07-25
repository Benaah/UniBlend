<?php

namespace App\Http\Controllers;

use App\Models\Club;
use Illuminate\Http\Request;

class ClubController extends Controller
{
    public function index()
    {
        return Club::all();
    }

    public function show(Club $club)
    {
        return $club;
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string',
            'description' => 'nullable|string',
        ]);

        $club = Club::create($validated);

        return response()->json($club, 201);
    }

    public function update(Request $request, Club $club)
    {
        $validated = $request->validate([
            'name' => 'sometimes|string',
            'description' => 'nullable|string',
        ]);

        $club->update($validated);

        return response()->json($club);
    }

    public function destroy(Club $club)
    {
        $club->delete();

        return response()->json(null, 204);
    }
}
