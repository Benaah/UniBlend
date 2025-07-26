<?php

namespace App\Filament\Resources\FlashClassResource\Pages;

use App\Filament\Resources\FlashClassResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditFlashClass extends EditRecord
{
    protected static string $resource = FlashClassResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\ViewAction::make(),
            Actions\DeleteAction::make(),
        ];
    }
}
