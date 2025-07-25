<?php

namespace App\Filament\Resources;

use App\Filament\Resources\MusicTrackResource\Pages;
use App\Models\MusicTrack;
use App\Models\User;
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
use Filament\Forms\Components\DatePicker;
use Filament\Tables\Actions\BulkActionGroup;
use Filament\Tables\Actions\DeleteBulkAction;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Filters\Filter;
use Illuminate\Database\Eloquent\Builder;

class MusicTrackResource extends Resource
{
    protected static ?string $model = MusicTrack::class;

    protected static ?string $navigationIcon = 'heroicon-o-musical-note';

    protected static ?string $navigationGroup = 'Music Management';

    protected static ?int $navigationSort = 1;

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                TextInput::make('title')
                    ->required()
                    ->maxLength(255)
                    ->columnSpanFull(),
                
                TextInput::make('artist')
                    ->required()
                    ->maxLength(255),
                
                TextInput::make('album')
                    ->maxLength(255),
                
                Select::make('genre')
                    ->options([
                        'Afrobeat' => 'Afrobeat',
                        'Benga' => 'Benga',
                        'Genge' => 'Genge',
                        'Gospel' => 'Gospel',
                        'Hip Hop' => 'Hip Hop',
                        'R&B' => 'R&B',
                        'Reggae' => 'Reggae',
                        'Traditional' => 'Traditional',
                        'Pop' => 'Pop',
                        'Jazz' => 'Jazz',
                        'Electronic' => 'Electronic',
                    ])
                    ->searchable()
                    ->required(),
                
                TextInput::make('duration')
                    ->label('Duration (seconds)')
                    ->numeric()
                    ->minValue(1),
                
                FileUpload::make('file_url')
                    ->label('Audio File')
                    ->acceptedFileTypes(['audio/mp3', 'audio/wav', 'audio/m4a', 'audio/ogg'])
                    ->directory('music/tracks')
                    ->visibility('public')
                    ->required()
                    ->columnSpanFull(),
                
                FileUpload::make('cover_image')
                    ->label('Cover Image')
                    ->image()
                    ->directory('music/covers')
                    ->visibility('public'),
                
                DatePicker::make('release_date')
                    ->native(false),
                
                Select::make('language')
                    ->options([
                        'en' => 'English',
                        'sw' => 'Swahili',
                        'ki' => 'Kikuyu',
                        'lu' => 'Luo',
                        'ka' => 'Kamba',
                        'me' => 'Meru',
                        'other' => 'Other',
                    ])
                    ->default('en'),
                
                Select::make('country')
                    ->options([
                        'KE' => 'Kenya',
                        'TZ' => 'Tanzania',
                        'UG' => 'Uganda',
                        'RW' => 'Rwanda',
                        'other' => 'Other',
                    ])
                    ->default('KE'),
                
                Textarea::make('lyrics')
                    ->rows(10)
                    ->columnSpanFull(),
                
                Toggle::make('is_local')
                    ->label('Local Track')
                    ->default(true),
                
                Toggle::make('is_featured')
                    ->label('Featured Track')
                    ->default(false),
                
                Select::make('status')
                    ->options([
                        'active' => 'Active',
                        'inactive' => 'Inactive',
                        'pending' => 'Pending Review',
                        'rejected' => 'Rejected',
                    ])
                    ->default('active')
                    ->required(),
                
                Select::make('uploaded_by')
                    ->label('Uploaded By')
                    ->relationship('uploader', 'name')
                    ->searchable()
                    ->preload(),
                
                TextInput::make('play_count')
                    ->label('Play Count')
                    ->numeric()
                    ->default(0)
                    ->disabled(),
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
                
                TextColumn::make('title')
                    ->searchable()
                    ->limit(30)
                    ->tooltip(function (TextColumn $column): ?string {
                        $state = $column->getState();
                        return strlen($state) > 30 ? $state : null;
                    }),
                
                TextColumn::make('artist')
                    ->searchable()
                    ->sortable(),
                
                TextColumn::make('album')
                    ->searchable()
                    ->toggleable(),
                
                BadgeColumn::make('genre')
                    ->colors([
                        'success' => 'Afrobeat',
                        'warning' => 'Benga',
                        'info' => 'Genge',
                        'primary' => 'Gospel',
                        'secondary' => 'Hip Hop',
                    ]),
                
                TextColumn::make('duration_formatted')
                    ->label('Duration')
                    ->sortable(query: function (Builder $query, string $direction): Builder {
                        return $query->orderBy('duration', $direction);
                    }),
                
                TextColumn::make('language')
                    ->badge()
                    ->toggleable(),
                
                BadgeColumn::make('status')
                    ->colors([
                        'success' => 'active',
                        'warning' => 'pending',
                        'secondary' => 'inactive',
                        'danger' => 'rejected',
                    ]),
                
                TextColumn::make('is_local')
                    ->label('Local')
                    ->formatStateUsing(fn (bool $state): string => $state ? '🇰🇪' : '🌍')
                    ->alignment('center'),
                
                TextColumn::make('is_featured')
                    ->label('Featured')
                    ->formatStateUsing(fn (bool $state): string => $state ? '⭐' : '')
                    ->alignment('center'),
                
                TextColumn::make('play_count')
                    ->label('Plays')
                    ->formatStateUsing(fn ($state) => number_format($state))
                    ->sortable(),
                
                TextColumn::make('uploader.name')
                    ->label('Uploaded By')
                    ->toggleable(isToggledHiddenByDefault: true),
                
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
                        'rejected' => 'Rejected',
                    ]),
                
                SelectFilter::make('genre')
                    ->options([
                        'Afrobeat' => 'Afrobeat',
                        'Benga' => 'Benga',
                        'Genge' => 'Genge',
                        'Gospel' => 'Gospel',
                        'Hip Hop' => 'Hip Hop',
                        'R&B' => 'R&B',
                        'Reggae' => 'Reggae',
                        'Traditional' => 'Traditional',
                        'Pop' => 'Pop',
                        'Jazz' => 'Jazz',
                        'Electronic' => 'Electronic',
                    ]),
                
                Filter::make('is_local')
                    ->query(fn (Builder $query): Builder => $query->where('is_local', true))
                    ->label('Local Tracks'),
                
                Filter::make('is_featured')
                    ->query(fn (Builder $query): Builder => $query->where('is_featured', true))
                    ->label('Featured Tracks'),
                
                Filter::make('popular')
                    ->query(fn (Builder $query): Builder => $query->where('play_count', '>', 1000))
                    ->label('Popular (>1K plays)'),
                
                SelectFilter::make('language')
                    ->options([
                        'en' => 'English',
                        'sw' => 'Swahili',
                        'ki' => 'Kikuyu',
                        'lu' => 'Luo',
                        'ka' => 'Kamba',
                        'me' => 'Meru',
                        'other' => 'Other',
                    ]),
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
                        ->label('Feature Tracks')
                        ->icon('heroicon-o-star')
                        ->color('info')
                        ->action(fn ($records) => $records->each->update(['is_featured' => true])),
                    
                    Tables\Actions\BulkAction::make('unfeature')
                        ->label('Remove Feature')
                        ->icon('heroicon-o-star')
                        ->color('gray')
                        ->action(fn ($records) => $records->each->update(['is_featured' => false])),
                ]),
            ])
            ->defaultSort('created_at', 'desc');
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListMusicTracks::route('/'),
            'create' => Pages\CreateMusicTrack::route('/create'),
            'view' => Pages\ViewMusicTrack::route('/{record}'),
            'edit' => Pages\EditMusicTrack::route('/{record}/edit'),
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
