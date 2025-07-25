<?php

namespace App\Filament\Resources\MusicTrackResource\Pages;

use App\Filament\Resources\MusicTrackResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditMusicTrack extends EditRecord
{
    protected static string $resource = MusicTrackResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\ViewAction::make(),
            Actions\DeleteAction::make(),
        ];
    }
}
