<?php

namespace App\Providers;

use App\Events\AnswerAccepted;
use App\Events\CommentCreated;
use App\Events\PostCreated;
use App\Events\VoteCast;
use App\Listeners\AwardPoints;
use App\Models\Category;
use App\Models\Comment;
use App\Models\Post;
use App\Models\Tag;
use App\Models\User;
use App\Observers\CategoryObserver;
use App\Observers\PostObserver;
use App\Observers\TagObserver;
use App\Observers\UserObserver;
use Illuminate\Cache\RateLimiting\Limit;
use Illuminate\Database\Eloquent\Relations\Relation;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        //
    }

    private function forceHttpsIfSecure(): void
    {
        if (app()->runningInConsole()) {
            return;
        }

        if (request()->isSecure()) {
            URL::forceScheme('https');
        }
    }

    public function boot(): void
    {
        $this->forceHttpsIfSecure();

        Relation::morphMap([
            'post' => Post::class,
            'comment' => Comment::class,
        ]);

        Category::observe(CategoryObserver::class);
        Tag::observe(TagObserver::class);
        Post::observe(PostObserver::class);
        User::observe(UserObserver::class);

        RateLimiter::for('api', fn (Request $request) => Limit::perMinute(60)->by($request->user()?->id ?: $request->ip()));

        RateLimiter::for('auth', fn (Request $request) => Limit::perMinute(5)->by($request->ip()));

        RateLimiter::for('reports', fn (Request $request) => Limit::perMinute(10)->by($request->user()?->id ?: $request->ip()));

        Event::listen(PostCreated::class, AwardPoints::class);
        Event::listen(CommentCreated::class, AwardPoints::class);
        Event::listen(AnswerAccepted::class, AwardPoints::class);
        Event::listen(VoteCast::class, AwardPoints::class);
    }
}
