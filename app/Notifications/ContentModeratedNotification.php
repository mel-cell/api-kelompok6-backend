<?php

namespace App\Notifications;

use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Notification;

class ContentModeratedNotification extends Notification implements ShouldQueue
{
    use Queueable;

    public function __construct(
        public string $targetType,
        public string $targetId,
        public string $targetTitle,
        public string $action,
        public ?string $reason,
        public User $moderator,
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
            'type' => 'content_moderated',
            'target_type' => $this->targetType,
            'target_id' => $this->targetId,
            'target_title' => $this->targetTitle,
            'action' => $this->action,
            'reason' => $this->reason,
            'moderator_id' => $this->moderator->id,
            'moderator_username' => $this->moderator->username,
        ];
    }
}
