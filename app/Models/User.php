<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Illuminate\Support\Str;
use Laravel\Sanctum\HasApiTokens;
use Laravel\Scout\Searchable;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable, Searchable;

    public $incrementing = false;

    protected $keyType = 'string';

    protected $fillable = [
        'username',
        'email',
        'password_hash',
        'avatar_url',
        'bio',
        'reputation_points',
        'level',
        'is_banned',
    ];

    protected $hidden = [
        'password_hash',
        'remember_token',
    ];

    protected static function boot(): void
    {
        parent::boot();
        static::creating(fn ($user) => $user->id ??= (string) Str::uuid());
    }

    protected function casts(): array
    {
        return [
            'is_banned' => 'boolean',
            'email_verified_at' => 'datetime',
        ];
    }

    public function getAuthPassword(): string
    {
        return $this->password_hash;
    }

    public function roles()
    {
        return $this->belongsToMany(Role::class, 'user_roles')
            ->withPivot('assigned_at');
    }

    public function followers()
    {
        return $this->hasMany(Follow::class, 'following_id');
    }

    public function following()
    {
        return $this->hasMany(Follow::class, 'follower_id');
    }

    public function pointsLogs()
    {
        return $this->hasMany(PointsLog::class);
    }

    public function posts()
    {
        return $this->hasMany(Post::class);
    }

    public function comments()
    {
        return $this->hasMany(Comment::class);
    }

    public function bookmarks()
    {
        return $this->hasMany(Bookmark::class);
    }

    public function shadowBans()
    {
        return $this->hasMany(ShadowBan::class);
    }

    public function activeShadowBan()
    {
        return $this->shadowBans()
            ->where('expires_at', '>', now())
            ->latest('created_at')
            ->first();
    }

    public function isShadowBanned(): bool
    {
        return $this->activeShadowBan() !== null;
    }

    public function canCreatePosts(): bool
    {
        $ban = $this->activeShadowBan();
        if (! $ban) {
            return true;
        }

        return $ban->restriction_type !== 'post' && $ban->restriction_type !== 'both';
    }

    public function canCreateComments(): bool
    {
        $ban = $this->activeShadowBan();
        if (! $ban) {
            return true;
        }

        return $ban->restriction_type !== 'comment' && $ban->restriction_type !== 'both';
    }
}
