<?php

namespace App\Filament\Resources\MusicGenreResource\Pages;

use App\Filament\Resources\MusicGenreResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditMusicGenre extends EditRecord
{
    protected static string $resource = MusicGenreResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
}
