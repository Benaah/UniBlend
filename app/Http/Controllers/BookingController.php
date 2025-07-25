<?php

namespace App\Http\Controllers;

use App\Models\Booking;
use Illuminate\Http\Request;

class BookingController extends Controller
{
    public function index()
    {
        return Booking::all();
    }

    public function show(Booking $booking)
    {
        return $booking;
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'service_id' => 'required|exists:services,id',
            'user_id' => 'required|exists:users,id',
            'pickup_location' => 'required|string',
            'dropoff_location' => 'required|string',
            'status' => 'required|string',
        ]);

        $booking = Booking::create($validated);

        return response()->json($booking, 201);
    }

    public function update(Request $request, Booking $booking)
    {
        $validated = $request->validate([
            'service_id' => 'sometimes|exists:services,id',
            'user_id' => 'sometimes|exists:users,id',
            'pickup_location' => 'sometimes|string',
            'dropoff_location' => 'sometimes|string',
            'status' => 'sometimes|string',
        ]);

        $booking->update($validated);

        return response()->json($booking);
    }

    public function destroy(Booking $booking)
    {
        $booking->delete();

        return response()->json(null, 204);
    }
}
