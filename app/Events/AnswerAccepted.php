<?php

namespace App\Events;

use App\Models\Comment;
use App\Models\Post;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class AnswerAccepted
{
    use Dispatchable, SerializesModels;

    public Post $post;

    public Comment $comment;

    public function __construct(Post $post, Comment $comment)
    {
        $this->post = $post;
        $this->comment = $comment;
    }
}
