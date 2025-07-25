<?php

namespace App\Filament\Resources\MusicGenreResource\Pages;

use App\Filament\Resources\MusicGenreResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListMusicGenres extends ListRecords
{
    protected static string $resource = MusicGenreResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}
