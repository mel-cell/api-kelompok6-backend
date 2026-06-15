<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

class UserResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'email' => $this->when(auth()->id() === $this->id, $this->email),
            'username' => $this->username,
            'avatar_url' => $this->avatar_url
                ? Storage::disk('public')->url($this->avatar_url)
                : 'https://ui-avatars.com/api/?name='.urlencode($this->username).'&background=random&color=fff&size=200',
            'bio' => $this->bio,
            'is_banned' => (bool) $this->is_banned,
            'is_shadow_banned' => $this->whenLoaded('shadowBans')
                ? $this->shadowBans->where('expires_at', '>', now())->isNotEmpty()
                : $this->isShadowBanned(),
            'reputation_points' => (int) $this->reputation_points,
            'level' => (int) $this->level,
            'created_at' => $this->created_at,
            'roles' => $this->whenLoaded('roles', fn () => $this->roles->map(fn ($r) => [
                'id' => $r->id,
                'name' => $r->name,
            ])),
            'followers_count' => (int) ($this->followers_count ?? 0),
            'following_count' => (int) ($this->following_count ?? 0),
            'posts_count' => (int) ($this->posts_count ?? 0),
        ];
    }
}
