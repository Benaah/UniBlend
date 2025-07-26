<?php

namespace App\Filament\Resources\FlashClassResource\Pages;

use App\Filament\Resources\FlashClassResource;
use Filament\Actions;
use Filament\Resources\Pages\ViewRecord;

class ViewFlashClass extends ViewRecord
{
    protected static string $resource = FlashClassResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\EditAction::make(),
        ];
    }
}
