<?php

namespace App\Providers;

use Illuminate\Support\Facades\Gate;
use Laravel\Horizon\Horizon;
use Laravel\Horizon\HorizonApplicationServiceProvider;

class HorizonServiceProvider extends HorizonApplicationServiceProvider
{
    public function boot(): void
    {
        parent::boot();
    }

    protected function authorization(): void
    {
        Horizon::auth(function ($request) {
            return (bool) ($request->user()?->roles->contains(fn ($r) => $r->name === 'admin'));
        });
    }

    protected function gate(): void
    {
        Gate::define('viewHorizon', function ($user = null) {
            return $user?->roles->contains(fn ($r) => $r->name === 'admin') ?? false;
        });
    }
}
