<?php

namespace App\Http\Controllers;

use App\Models\Wallet;
use Illuminate\Http\Request;

class WalletController extends Controller
{
    public function index()
    {
        return Wallet::all();
    }

    public function show(Wallet $wallet)
    {
        return $wallet;
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'user_id' => 'required|exists:users,id',
            'balance' => 'required|numeric',
            'transaction_history' => 'nullable|array',
        ]);

        $wallet = Wallet::create($validated);

        return response()->json($wallet, 201);
    }

    public function update(Request $request, Wallet $wallet)
    {
        $validated = $request->validate([
            'balance' => 'sometimes|numeric',
            'transaction_history' => 'nullable|array',
        ]);

        $wallet->update($validated);

        return response()->json($wallet);
    }

    public function destroy(Wallet $wallet)
    {
        $wallet->delete();

        return response()->json(null, 204);
    }
}
