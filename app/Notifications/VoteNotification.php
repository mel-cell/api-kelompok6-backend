<?php

namespace App\Notifications;

use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Notification;
use Illuminate\Support\Facades\Storage;

class VoteNotification extends Notification implements ShouldQueue
{
    use Queueable;

    public function __construct(
        public User $actor,
        public string $voteType,
        public string $referenceId,
        public string $referenceType,
    ) {
        $this->queue = 'notifications';
    }

    public function via(object $notifiable): array
    {
        return ['database'];
    }

    public function toArray(object $notifiable): array
    {
        return [
            'actor_id' => $this->actor->id,
            'actor_username' => $this->actor->username,
            'actor_avatar_url' => $this->actor->avatar_url ? Storage::url($this->actor->avatar_url) : null,
            'type' => 'vote',
            'vote_type' => $this->voteType,
            'reference_id' => $this->referenceId,
            'reference_type' => $this->referenceType,
        ];
    }
}
