<?php

namespace App\Notifications;

use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Notification;

class CommentNotification extends Notification implements ShouldQueue
{
    use Queueable;

    public $queue = 'notifications';

    public function __construct(
        public User $actor,
        public string $postId,
        public string $postTitle,
    ) {}

    public function via(object $notifiable): array
    {
        return ['database'];
    }

    public function toArray(object $notifiable): array
    {
        return [
            'actor_id' => $this->actor->id,
            'actor_username' => $this->actor->username,
            'actor_avatar_url' => $this->actor->avatar_url,
            'type' => 'comment',
            'reference_id' => $this->postId,
            'reference_type' => 'post',
            'post_title' => $this->postTitle,
        ];
    }
}
