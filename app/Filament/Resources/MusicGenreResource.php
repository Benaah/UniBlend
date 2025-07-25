<?php

namespace App\Filament\Resources;

use App\Filament\Resources\MusicGenreResource\Pages;
use App\Models\MusicGenre;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Columns\ImageColumn;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Toggle;
use Filament\Tables\Actions\BulkActionGroup;
use Filament\Tables\Actions\DeleteBulkAction;
use Filament\Tables\Filters\Filter;
use Illuminate\Database\Eloquent\Builder;

class MusicGenreResource extends Resource
{
    protected static ?string $model = MusicGenre::class;

    protected static ?string $navigationIcon = 'heroicon-o-tag';

    protected static ?string $navigationGroup = 'Music Management';

    protected static ?int $navigationSort = 3;

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                TextInput::make('name')
                    ->required()
                    ->unique(ignoreRecord: true)
                    ->maxLength(255),
                
                Textarea::make('description')
                    ->rows(4)
                    ->columnSpanFull(),
                
                FileUpload::make('cover_image')
                    ->label('Cover Image')
                    ->image()
                    ->directory('music/genre-covers')
                    ->visibility('public'),
                
                Toggle::make('is_local')
                    ->label('Local Genre')
                    ->default(true),
                
                Toggle::make('is_featured')
                    ->label('Featured Genre')
                    ->default(false),
                
                TextInput::make('sort_order')
                    ->label('Sort Order')
                    ->numeric()
                    ->default(0)
                    ->helperText('Lower numbers appear first'),
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
                    ->sortable(),
                
                TextColumn::make('description')
                    ->limit(50)
                    ->tooltip(function (TextColumn $column): ?string {
                        $state = $column->getState();
                        return strlen($state) > 50 ? $state : null;
                    }),
                
                TextColumn::make('tracks_count')
                    ->label('Tracks')
                    ->counts('tracks')
                    ->sortable()
                    ->badge()
                    ->color('info'),
                
                TextColumn::make('is_local')
                    ->label('Local')
                    ->formatStateUsing(fn (bool $state): string => $state ? '🇰🇪' : '🌍')
                    ->alignment('center'),
                
                TextColumn::make('is_featured')
                    ->label('Featured')
                    ->formatStateUsing(fn (bool $state): string => $state ? '⭐' : '')
                    ->alignment('center'),
                
                TextColumn::make('sort_order')
                    ->label('Order')
                    ->sortable(),
                
                TextColumn::make('created_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                Filter::make('is_local')
                    ->query(fn (Builder $query): Builder => $query->where('is_local', true))
                    ->label('Local Genres'),
                
                Filter::make('is_featured')
                    ->query(fn (Builder $query): Builder => $query->where('is_featured', true))
                    ->label('Featured Genres'),
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
                Tables\Actions\DeleteAction::make(),
            ])
            ->bulkActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                    
                    Tables\Actions\BulkAction::make('feature')
                        ->label('Feature Genres')
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
            ->defaultSort('sort_order');
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListMusicGenres::route('/'),
            'create' => Pages\CreateMusicGenre::route('/create'),
            'edit' => Pages\EditMusicGenre::route('/{record}/edit'),
        ];
    }
}
