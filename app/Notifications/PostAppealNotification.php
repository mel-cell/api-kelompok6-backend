<?php

namespace App\Notifications;

use App\Models\Post;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Notification;

class PostAppealNotification extends Notification implements ShouldQueue
{
    use Queueable;

    public function __construct(
        public Post $post,
        public string $reason,
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
            'type' => 'post_appeal',
            'post_id' => $this->post->id,
            'post_title' => $this->post->title,
            'appeal_reason' => $this->reason,
            'author_id' => $this->post->user_id,
        ];
    }
}
