<?php

namespace App\Observers;

use App\Models\Post;
use Illuminate\Support\Facades\Cache;

class PostObserver
{
    public function created(): void
    {
        Cache::tags('posts')->flush();
    }

    public function updated(Post $post): void
    {
        Cache::tags('posts')->flush();
        Cache::forget("post_{$post->id}");
    }

    public function deleted(Post $post): void
    {
        Cache::tags('posts')->flush();
        Cache::forget("post_{$post->id}");
    }
}
