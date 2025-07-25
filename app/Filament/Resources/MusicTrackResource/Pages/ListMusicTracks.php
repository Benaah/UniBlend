<?php

namespace App\Filament\Resources\MusicTrackResource\Pages;

use App\Filament\Resources\MusicTrackResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListMusicTracks extends ListRecords
{
    protected static string $resource = MusicTrackResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}
