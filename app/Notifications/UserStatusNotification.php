<?php

namespace App\Notifications;

use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Notification;

class UserStatusNotification extends Notification implements ShouldQueue
{
    use Queueable;

    public function __construct(
        public string $action,
        public ?string $reason,
        public User $actor,
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
            'type' => 'user_status',
            'action' => $this->action,
            'reason' => $this->reason,
            'actor_id' => $this->actor->id,
            'actor_username' => $this->actor->username,
        ];
    }
}
