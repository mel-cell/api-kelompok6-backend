<?php

namespace App\Listeners;

use App\Events\CommentCreated;
use App\Models\Notification;
use Illuminate\Contracts\Queue\ShouldQueue;

class CreateNotification implements ShouldQueue
{
    public function handle(CommentCreated $event): void
    {
        $comment = $event->comment;
        $postOwner = $comment->post->user;

        if ($postOwner->id !== $comment->user_id) {
            Notification::create([
                'user_id' => $postOwner->id,
                'actor_id' => $comment->user_id,
                'type' => 'comment',
                'reference_id' => $comment->post_id,
                'reference_type' => 'post',
            ]);
        }
    }
}
