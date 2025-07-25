<?php

namespace App\Http\Controllers;

use App\Models\Thread;
use Illuminate\Http\Request;

class ThreadController extends Controller
{
    public function index()
    {
        return Thread::all();
    }

    public function show(Thread $thread)
    {
        return $thread;
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string',
            'content' => 'required|string',
            'author_id' => 'required|exists:users,id',
            'course_id' => 'nullable|exists:courses,id',
            'club_id' => 'nullable|exists:clubs,id',
        ]);

        $thread = Thread::create($validated);

        return response()->json($thread, 201);
    }

    public function update(Request $request, Thread $thread)
    {
        $validated = $request->validate([
            'title' => 'sometimes|string',
            'content' => 'sometimes|string',
            'author_id' => 'sometimes|exists:users,id',
            'course_id' => 'nullable|exists:courses,id',
            'club_id' => 'nullable|exists:clubs,id',
        ]);

        $thread->update($validated);

        return response()->json($thread);
    }

    public function destroy(Thread $thread)
    {
        $thread->delete();

        return response()->json(null, 204);
    }
}
