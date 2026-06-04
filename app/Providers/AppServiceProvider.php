<?php

namespace App\Providers;

use App\Events\AnswerAccepted;
use App\Events\CommentCreated;
use App\Events\PostCreated;
use App\Events\VoteCast;
use App\Listeners\AwardPoints;
use App\Listeners\CreateNotification;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        //
    }

    public function boot(): void
    {
        Event::listen(PostCreated::class, AwardPoints::class);
        Event::listen(CommentCreated::class, AwardPoints::class);
        Event::listen(CommentCreated::class, CreateNotification::class);
        Event::listen(AnswerAccepted::class, AwardPoints::class);
        Event::listen(VoteCast::class, AwardPoints::class);
    }
}
