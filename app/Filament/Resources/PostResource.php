<?php

namespace App\Filament\Resources;

use App\Filament\Resources\PostResource\Pages;
use App\Models\Post;
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
use Filament\Tables\Actions\BulkActionGroup;
use Filament\Tables\Actions\DeleteBulkAction;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Filters\Filter;
use Illuminate\Database\Eloquent\Builder;

class PostResource extends Resource
{
    protected static ?string $model = Post::class;

    protected static ?string $navigationIcon = 'heroicon-o-photo';

    protected static ?string $navigationGroup = 'Content Management';

    protected static ?int $navigationSort = 2;

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Textarea::make('caption')
                    ->required()
                    ->rows(4)
                    ->columnSpanFull(),
                
                Select::make('user_id')
                    ->label('User')
                    ->relationship('user', 'name')
                    ->searchable()
                    ->preload()
                    ->required(),
                
                FileUpload::make('images')
                    ->label('Images')
                    ->multiple()
                    ->image()
                    ->reorderable()
                    ->directory('posts/images')
                    ->visibility('public')
                    ->columnSpanFull(),
                
                FileUpload::make('videos')
                    ->label('Videos')
                    ->multiple()
                    ->acceptedFileTypes(['video/mp4', 'video/avi', 'video/mov'])
                    ->directory('posts/videos')
                    ->visibility('public')
                    ->columnSpanFull(),
                
                Select::make('status')
                    ->options([
                        'published' => 'Published',
                        'draft' => 'Draft',
                        'flagged' => 'Flagged',
                        'pending' => 'Pending Review',
                        'removed' => 'Removed',
                    ])
                    ->default('published')
                    ->required(),
                
                Toggle::make('is_featured')
                    ->label('Feature Post')
                    ->default(false),
                
                Toggle::make('allow_comments')
                    ->label('Allow Comments')
                    ->default(true),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('id')
                    ->sortable(),
                
                TextColumn::make('caption')
                    ->searchable()
                    ->limit(50)
                    ->tooltip(function (TextColumn $column): ?string {
                        $state = $column->getState();
                        return strlen($state) > 50 ? $state : null;
                    }),
                
                TextColumn::make('user.name')
                    ->label('Author')
                    ->searchable()
                    ->sortable(),
                
                ImageColumn::make('images')
                    ->label('Preview')
                    ->getStateUsing(function ($record) {
                        $images = $record->images;
                        return is_array($images) && !empty($images) ? $images[0] : null;
                    })
                    ->size(40)
                    ->circular(),
                
                TextColumn::make('images_count')
                    ->label('Images')
                    ->getStateUsing(function ($record) {
                        return is_array($record->images) ? count($record->images) : 0;
                    })
                    ->alignment('center'),
                
                TextColumn::make('videos_count')
                    ->label('Videos')
                    ->getStateUsing(function ($record) {
                        return is_array($record->videos) ? count($record->videos) : 0;
                    })
                    ->alignment('center'),
                
                BadgeColumn::make('status')
                    ->colors([
                        'success' => 'published',
                        'warning' => 'pending',
                        'secondary' => 'draft',
                        'danger' => 'flagged',
                        'gray' => 'removed',
                    ]),
                
                TextColumn::make('is_featured')
                    ->label('Featured')
                    ->formatStateUsing(fn (bool $state): string => $state ? '⭐' : '')
                    ->alignment('center'),
                
                TextColumn::make('likes_count')
                    ->label('Likes')
                    ->counts('likes')
                    ->sortable(),
                
                TextColumn::make('comments_count')
                    ->label('Comments')
                    ->counts('comments')
                    ->sortable(),
                
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
                SelectFilter::make('status')
                    ->options([
                        'published' => 'Published',
                        'draft' => 'Draft',
                        'flagged' => 'Flagged',
                        'pending' => 'Pending Review',
                        'removed' => 'Removed',
                    ]),
                
                SelectFilter::make('user')
                    ->relationship('user', 'name')
                    ->searchable()
                    ->preload(),
                
                Filter::make('is_featured')
                    ->query(fn (Builder $query): Builder => $query->where('is_featured', true))
                    ->label('Featured Posts'),
                
                Filter::make('has_images')
                    ->query(fn (Builder $query): Builder => $query->whereNotNull('images'))
                    ->label('Has Images'),
                
                Filter::make('has_videos')
                    ->query(fn (Builder $query): Builder => $query->whereNotNull('videos'))
                    ->label('Has Videos'),
                
                Filter::make('created_at')
                    ->form([
                        Forms\Components\DatePicker::make('created_from'),
                        Forms\Components\DatePicker::make('created_until'),
                    ])
                    ->query(function (Builder $query, array $data): Builder {
                        return $query
                            ->when(
                                $data['created_from'],
                                fn (Builder $query, $date): Builder => $query->whereDate('created_at', '>=', $date),
                            )
                            ->when(
                                $data['created_until'],
                                fn (Builder $query, $date): Builder => $query->whereDate('created_at', '<=', $date),
                            );
                    }),
            ])
            ->actions([
                Tables\Actions\ViewAction::make(),
                Tables\Actions\EditAction::make(),
                Tables\Actions\DeleteAction::make(),
            ])
            ->bulkActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                    
                    Tables\Actions\BulkAction::make('publish')
                        ->label('Publish')
                        ->icon('heroicon-o-check-circle')
                        ->color('success')
                        ->action(fn ($records) => $records->each->update(['status' => 'published'])),
                    
                    Tables\Actions\BulkAction::make('draft')
                        ->label('Move to Draft')
                        ->icon('heroicon-o-document')
                        ->color('warning')
                        ->action(fn ($records) => $records->each->update(['status' => 'draft'])),
                    
                    Tables\Actions\BulkAction::make('flag')
                        ->label('Flag for Review')
                        ->icon('heroicon-o-flag')
                        ->color('danger')
                        ->action(fn ($records) => $records->each->update(['status' => 'flagged'])),
                    
                    Tables\Actions\BulkAction::make('feature')
                        ->label('Feature Posts')
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
            'index' => Pages\ListPosts::route('/'),
            'create' => Pages\CreatePost::route('/create'),
            'view' => Pages\ViewPost::route('/{record}'),
            'edit' => Pages\EditPost::route('/{record}/edit'),
        ];
    }

    public static function getNavigationBadge(): ?string
    {
        return static::getModel()::whereIn('status', ['pending', 'flagged'])->count() ?: null;
    }

    public static function getNavigationBadgeColor(): ?string
    {
        return static::getModel()::whereIn('status', ['pending', 'flagged'])->count() > 0 ? 'danger' : null;
    }
}
