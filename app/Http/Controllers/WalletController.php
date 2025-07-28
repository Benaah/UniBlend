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

    public function deposit(Request $request)
    {
        $validated = $request->validate([
            'user_id' => 'required|exists:users,id',
            'amount' => 'required|numeric|min:0.01',
            'payment_method' => 'required|string',
        ]);

        $wallet = Wallet::firstOrCreate(
            ['user_id' => $validated['user_id']],
            ['balance' => 0, 'transaction_history' => []]
        );

        $wallet->balance += $validated['amount'];

        $transaction = [
            'type' => 'deposit',
            'amount' => $validated['amount'],
            'payment_method' => $validated['payment_method'],
            'timestamp' => now()->toDateTimeString(),
        ];

        $history = $wallet->transaction_history ?? [];
        $history[] = $transaction;
        $wallet->transaction_history = $history;

        $wallet->save();

        return response()->json($wallet);
    }

    public function withdraw(Request $request)
    {
        $validated = $request->validate([
            'user_id' => 'required|exists:users,id',
            'amount' => 'required|numeric|min:0.01',
        ]);

        $wallet = Wallet::where('user_id', $validated['user_id'])->first();

        if (!$wallet) {
            return response()->json(['error' => 'Wallet not found'], 404);
        }

        if ($wallet->balance < $validated['amount']) {
            return response()->json(['error' => 'Insufficient balance'], 400);
        }

        $wallet->balance -= $validated['amount'];

        $transaction = [
            'type' => 'withdraw',
            'amount' => $validated['amount'],
            'timestamp' => now()->toDateTimeString(),
        ];

        $history = $wallet->transaction_history ?? [];
        $history[] = $transaction;
        $wallet->transaction_history = $history;

        $wallet->save();

        return response()->json($wallet);
    }
}
