<?php

namespace App\Http\Controllers;

use App\Models\Notification;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    public function index()
    {
        return Notification::all();
    }

    public function show(Notification $notification)
    {
        return $notification;
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'type' => 'required|string',
            'message' => 'required|string',
            'read_status' => 'required|boolean',
            'user_id' => 'required|exists:users,id',
        ]);

        $notification = Notification::create($validated);

        return response()->json($notification, 201);
    }

    public function update(Request $request, Notification $notification)
    {
        $validated = $request->validate([
            'type' => 'sometimes|string',
            'message' => 'sometimes|string',
            'read_status' => 'sometimes|boolean',
            'user_id' => 'sometimes|exists:users,id',
        ]);

        $notification->update($validated);

        return response()->json($notification);
    }

    public function destroy(Notification $notification)
    {
        $notification->delete();

        return response()->json(null, 204);
    }
}
