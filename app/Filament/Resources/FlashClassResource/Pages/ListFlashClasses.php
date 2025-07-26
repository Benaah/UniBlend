<?php

namespace App\Filament\Resources\FlashClassResource\Pages;

use App\Filament\Resources\FlashClassResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListFlashClasses extends ListRecords
{
    protected static string $resource = FlashClassResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}
