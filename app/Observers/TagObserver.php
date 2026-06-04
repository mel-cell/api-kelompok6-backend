<?php

namespace App\Observers;

use App\Models\Tag;
use Illuminate\Support\Facades\Cache;

class TagObserver
{
    public function created(): void
    {
        Cache::forget('tags_all');
    }

    public function updated(Tag $tag): void
    {
        Cache::forget('tags_all');
        Cache::forget("tag_{$tag->id}");
    }

    public function deleted(Tag $tag): void
    {
        Cache::forget('tags_all');
        Cache::forget("tag_{$tag->id}");
    }
}
