<?php

namespace App\Http\Controllers;

use App\Models\Notification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class NotificationController extends Controller
{
    public function index(Request $request)
    {
        // Authorization: Only return notifications for authenticated user
        $user = $request->user();
        return Notification::where('user_id', $user->id)->get();
    }

    public function show(Request $request, Notification $notification)
    {
        // Authorization: Only allow access if notification belongs to user
        if ($request->user()->id !== $notification->user_id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }
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

        // Authorization: Only allow creating notification for self or admin
        if ($request->user()->id !== $validated['user_id'] && !$request->user()->hasRole('admin')) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $notification = Notification::create($validated);

        Log::info('Notification created', ['notification_id' => $notification->id, 'created_by' => $request->user()->id]);

        return response()->json($notification, 201);
    }

    public function update(Request $request, Notification $notification)
    {
        // Authorization: Only allow update if notification belongs to user or admin
        if ($request->user()->id !== $notification->user_id && !$request->user()->hasRole('admin')) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $validated = $request->validate([
            'type' => 'sometimes|string',
            'message' => 'sometimes|string',
            'read_status' => 'sometimes|boolean',
            'user_id' => 'sometimes|exists:users,id',
        ]);

        $notification->update($validated);

        Log::info('Notification updated', ['notification_id' => $notification->id, 'updated_by' => $request->user()->id]);

        return response()->json($notification);
    }

    public function destroy(Request $request, Notification $notification)
    {
        // Authorization: Only allow delete if notification belongs to user or admin
        if ($request->user()->id !== $notification->user_id && !$request->user()->hasRole('admin')) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $notification->delete();

        Log::info('Notification deleted', ['notification_id' => $notification->id, 'deleted_by' => $request->user()->id]);

        return response()->json(null, 204);
    }
}
