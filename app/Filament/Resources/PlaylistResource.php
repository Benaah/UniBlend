<?php

namespace App\Filament\Resources;

use App\Filament\Resources\PlaylistResource\Pages;
use App\Models\Playlist;
use App\Models\User;
use App\Models\MusicTrack;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Columns\BadgeColumn;
use Filament\Tables\Columns\ImageColumn;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Toggle;
use Filament\Forms\Components\Repeater;
use Filament\Tables\Actions\BulkActionGroup;
use Filament\Tables\Actions\DeleteBulkAction;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Filters\Filter;
use Illuminate\Database\Eloquent\Builder;

class PlaylistResource extends Resource
{
    protected static ?string $model = Playlist::class;

    protected static ?string $navigationIcon = 'heroicon-o-queue-list';

    protected static ?string $navigationGroup = 'Music Management';

    protected static ?int $navigationSort = 2;

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                TextInput::make('name')
                    ->required()
                    ->maxLength(255)
                    ->columnSpanFull(),
                
                Textarea::make('description')
                    ->rows(4)
                    ->columnSpanFull(),
                
                Select::make('user_id')
                    ->label('Creator')
                    ->relationship('user', 'name')
                    ->searchable()
                    ->preload()
                    ->required(),
                
                FileUpload::make('cover_image')
                    ->label('Cover Image')
                    ->image()
                    ->directory('music/playlist-covers')
                    ->visibility('public'),
                
                Toggle::make('is_public')
                    ->label('Public Playlist')
                    ->default(true),
                
                Toggle::make('is_featured')
                    ->label('Featured Playlist')
                    ->default(false),
                
                Select::make('status')
                    ->options([
                        'active' => 'Active',
                        'inactive' => 'Inactive',
                        'pending' => 'Pending Review',
                    ])
                    ->default('active')
                    ->required(),
                
                TextInput::make('play_count')
                    ->label('Play Count')
                    ->numeric()
                    ->default(0)
                    ->disabled(),
                
                Select::make('tracks')
                    ->label('Tracks')
                    ->relationship('tracks', 'title')
                    ->multiple()
                    ->searchable()
                    ->preload()
                    ->getOptionLabelFromRecordUsing(fn (MusicTrack $record): string => "{$record->title} - {$record->artist}")
                    ->columnSpanFull(),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('id')
                    ->sortable(),
                
                ImageColumn::make('cover_image')
                    ->size(50)
                    ->circular(),
                
                TextColumn::make('name')
                    ->searchable()
                    ->limit(30)
                    ->tooltip(function (TextColumn $column): ?string {
                        $state = $column->getState();
                        return strlen($state) > 30 ? $state : null;
                    }),
                
                TextColumn::make('user.name')
                    ->label('Creator')
                    ->searchable()
                    ->sortable(),
                
                TextColumn::make('tracks_count')
                    ->label('Tracks')
                    ->counts('tracks')
                    ->sortable()
                    ->badge()
                    ->color('info'),
                
                TextColumn::make('followers_count')
                    ->label('Followers')
                    ->counts('followers')
                    ->sortable()
                    ->badge()
                    ->color('success'),
                
                BadgeColumn::make('status')
                    ->colors([
                        'success' => 'active',
                        'warning' => 'pending',
                        'secondary' => 'inactive',
                    ]),
                
                TextColumn::make('is_public')
                    ->label('Public')
                    ->formatStateUsing(fn (bool $state): string => $state ? '🌍' : '🔒')
                    ->alignment('center'),
                
                TextColumn::make('is_featured')
                    ->label('Featured')
                    ->formatStateUsing(fn (bool $state): string => $state ? '⭐' : '')
                    ->alignment('center'),
                
                TextColumn::make('play_count')
                    ->label('Plays')
                    ->formatStateUsing(fn ($state) => number_format($state))
                    ->sortable(),
                
                TextColumn::make('total_duration')
                    ->label('Duration')
                    ->formatStateUsing(function ($state) {
                        $minutes = floor($state / 60);
                        $seconds = $state % 60;
                        return sprintf('%d:%02d', $minutes, $seconds);
                    })
                    ->toggleable(),
                
                TextColumn::make('created_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                SelectFilter::make('status')
                    ->options([
                        'active' => 'Active',
                        'inactive' => 'Inactive',
                        'pending' => 'Pending Review',
                    ]),
                
                SelectFilter::make('user')
                    ->relationship('user', 'name')
                    ->searchable()
                    ->preload(),
                
                Filter::make('is_public')
                    ->query(fn (Builder $query): Builder => $query->where('is_public', true))
                    ->label('Public Playlists'),
                
                Filter::make('is_featured')
                    ->query(fn (Builder $query): Builder => $query->where('is_featured', true))
                    ->label('Featured Playlists'),
                
                Filter::make('popular')
                    ->query(fn (Builder $query): Builder => $query->where('play_count', '>', 100))
                    ->label('Popular (>100 plays)'),
            ])
            ->actions([
                Tables\Actions\ViewAction::make(),
                Tables\Actions\EditAction::make(),
                Tables\Actions\DeleteAction::make(),
            ])
            ->bulkActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                    
                    Tables\Actions\BulkAction::make('activate')
                        ->label('Activate')
                        ->icon('heroicon-o-check-circle')
                        ->color('success')
                        ->action(fn ($records) => $records->each->update(['status' => 'active'])),
                    
                    Tables\Actions\BulkAction::make('deactivate')
                        ->label('Deactivate')
                        ->icon('heroicon-o-x-circle')
                        ->color('warning')
                        ->action(fn ($records) => $records->each->update(['status' => 'inactive'])),
                    
                    Tables\Actions\BulkAction::make('feature')
                        ->label('Feature Playlists')
                        ->icon('heroicon-o-star')
                        ->color('info')
                        ->action(fn ($records) => $records->each->update(['is_featured' => true])),
                    
                    Tables\Actions\BulkAction::make('make_public')
                        ->label('Make Public')
                        ->icon('heroicon-o-globe-alt')
                        ->color('success')
                        ->action(fn ($records) => $records->each->update(['is_public' => true])),
                    
                    Tables\Actions\BulkAction::make('make_private')
                        ->label('Make Private')
                        ->icon('heroicon-o-lock-closed')
                        ->color('gray')
                        ->action(fn ($records) => $records->each->update(['is_public' => false])),
                ]),
            ])
            ->defaultSort('created_at', 'desc');
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListPlaylists::route('/'),
            'create' => Pages\CreatePlaylist::route('/create'),
            'view' => Pages\ViewPlaylist::route('/{record}'),
            'edit' => Pages\EditPlaylist::route('/{record}/edit'),
        ];
    }

    public static function getNavigationBadge(): ?string
    {
        return static::getModel()::where('status', 'pending')->count() ?: null;
    }

    public static function getNavigationBadgeColor(): ?string
    {
        return static::getModel()::where('status', 'pending')->count() > 0 ? 'warning' : null;
    }
}
