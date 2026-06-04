<?php

namespace App\Observers;

use App\Models\Category;
use Illuminate\Support\Facades\Cache;

class CategoryObserver
{
    public function created(): void
    {
        Cache::forget('categories_all');
    }

    public function updated(Category $category): void
    {
        Cache::forget('categories_all');
        Cache::forget("category_{$category->id}");
    }

    public function deleted(Category $category): void
    {
        Cache::forget('categories_all');
        Cache::forget("category_{$category->id}");
    }
}
