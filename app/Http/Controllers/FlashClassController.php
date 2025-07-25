<?php

namespace App\Http\Controllers;

use App\Models\FlashClass;
use Illuminate\Http\Request;

class FlashClassController extends Controller
{
    public function index()
    {
        return FlashClass::all();
    }

    public function show(FlashClass $flashClass)
    {
        return $flashClass;
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string',
            'description' => 'nullable|string',
            'video_url' => 'required|string',
            'course_id' => 'required|exists:courses,id',
        ]);

        $flashClass = FlashClass::create($validated);

        return response()->json($flashClass, 201);
    }

    public function update(Request $request, FlashClass $flashClass)
    {
        $validated = $request->validate([
            'title' => 'sometimes|string',
            'description' => 'nullable|string',
            'video_url' => 'sometimes|string',
            'course_id' => 'sometimes|exists:courses,id',
        ]);

        $flashClass->update($validated);

        return response()->json($flashClass);
    }

    public function destroy(FlashClass $flashClass)
    {
        $flashClass->delete();

        return response()->json(null, 204);
    }
}
