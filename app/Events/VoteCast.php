<?php

namespace App\Events;

use App\Models\User;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class VoteCast
{
    use Dispatchable, SerializesModels;

    public User $targetOwner;

    public string $actionType;

    public int $pointsDelta;

    public string $referenceId;

    public string $referenceType;

    public function __construct(User $targetOwner, string $actionType, int $pointsDelta, string $referenceId, string $referenceType)
    {
        $this->targetOwner = $targetOwner;
        $this->actionType = $actionType;
        $this->pointsDelta = $pointsDelta;
        $this->referenceId = $referenceId;
        $this->referenceType = $referenceType;
    }
}
