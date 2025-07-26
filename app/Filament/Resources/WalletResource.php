<?php

namespace App\Filament\Resources;

use App\Filament\Resources\WalletResource\Pages;
use App\Models\Wallet;
use App\Models\User;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Filament\Tables\Columns\TextColumn;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Tables\Actions\BulkActionGroup;
use Filament\Tables\Actions\DeleteBulkAction;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Filters\Filter;
use Illuminate\Database\Eloquent\Builder;

class WalletResource extends Resource
{
    protected static ?string $model = Wallet::class;

    protected static ?string $navigationIcon = 'heroicon-o-banknotes';

    protected static ?string $navigationGroup = 'Financial Management';

    protected static ?int $navigationSort = 1;

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Select::make('user_id')
                    ->label('User')
                    ->relationship('user', 'name')
                    ->searchable()
                    ->preload()
                    ->required(),

                TextInput::make('balance')
                    ->label('Balance (Ksh)')
                    ->numeric()
                    ->prefix('ksh')
                    ->default(0)
                    ->required(),

                Textarea::make('transaction_history')
                    ->label('Transaction History (JSON)')
                    ->rows(6)
                    ->columnSpanFull()
                    ->helperText('JSON format for transaction history'),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('id')
                    ->sortable(),

                TextColumn::make('user.name')
                    ->label('User')
                    ->searchable()
                    ->sortable(),

                TextColumn::make('user.email')
                    ->label('Email')
                    ->searchable()
                    ->toggleable(),

                TextColumn::make('balance')
                    ->label('Balance')
                    ->money('KES')
                    ->sortable()
                    ->color(fn ($state) => $state > 0 ? 'success' : ($state < 0 ? 'danger' : 'gray')),

                TextColumn::make('transaction_count')
                    ->label('Transactions')
                    ->getStateUsing(function ($record) {
                        return is_array($record->transaction_history) ? count($record->transaction_history) : 0;
                    })
                    ->badge()
                    ->color('info'),

                TextColumn::make('last_transaction')
                    ->label('Last Activity')
                    ->getStateUsing(function ($record) {
                        if (is_array($record->transaction_history) && !empty($record->transaction_history)) {
                            $lastTransaction = end($record->transaction_history);
                            return isset($lastTransaction['date']) ? $lastTransaction['date'] : 'N/A';
                        }
                        return 'No transactions';
                    })
                    ->dateTime()
                    ->toggleable(),

                TextColumn::make('created_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),

                TextColumn::make('updated_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                SelectFilter::make('user')
                    ->relationship('user', 'name')
                    ->searchable()
                    ->preload(),

                Filter::make('positive_balance')
                    ->query(fn (Builder $query): Builder => $query->where('balance', '>', 0))
                    ->label('Positive Balance'),

                Filter::make('negative_balance')
                    ->query(fn (Builder $query): Builder => $query->where('balance', '<', 0))
                    ->label('Negative Balance'),

                Filter::make('zero_balance')
                    ->query(fn (Builder $query): Builder => $query->where('balance', '=', 0))
                    ->label('Zero Balance'),

                Filter::make('high_balance')
                    ->query(fn (Builder $query): Builder => $query->where('balance', '>', 50000))
                    ->label('High Balance (>Ksh 50,000)'),
            ])
            ->actions([
                Tables\Actions\ViewAction::make(),
                Tables\Actions\EditAction::make(),
                Tables\Actions\DeleteAction::make(),
            ])
            ->bulkActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ])
            ->defaultSort('balance', 'desc');
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListWallets::route('/'),
            'create' => Pages\CreateWallet::route('/create'),
            'view' => Pages\ViewWallet::route('/{record}'),
            'edit' => Pages\EditWallet::route('/{record}/edit'),
        ];
    }

    public static function getNavigationBadge(): ?string
    {
        return static::getModel()::where('balance', '<', 0)->count() ?: null;
    }

    public static function getNavigationBadgeColor(): ?string
    {
        return static::getModel()::where('balance', '<', 0)->count() > 0 ? 'danger' : null;
    }
}
