<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;
use Laravel\Scout\Searchable;

class Post extends Model
{
    use Searchable;

    public $incrementing = false;

    protected $keyType = 'string';

    protected $fillable = [
        'user_id', 'category_id', 'title', 'body',
        'status', 'view_count', 'vote_score',
        'is_answered', 'accepted_answer_id',
    ];

    protected function casts(): array
    {
        return [
            'is_answered' => 'boolean',
        ];
    }

    public function toSearchableArray(): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'body' => $this->body,
            'status' => $this->status,
        ];
    }

    protected static function boot(): void
    {
        parent::boot();
        static::creating(fn ($post) => $post->id ??= (string) Str::uuid());
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function tags()
    {
        return $this->belongsToMany(Tag::class, 'post_tags');
    }

    public function comments()
    {
        return $this->hasMany(Comment::class);
    }

    public function acceptedAnswer()
    {
        return $this->belongsTo(Comment::class, 'accepted_answer_id');
    }

    public function editHistories()
    {
        return $this->hasMany(PostEditHistory::class);
    }

    public function bookmarks()
    {
        return $this->hasMany(Bookmark::class);
    }

    public function votes()
    {
        return $this->morphMany(Vote::class, 'target');
    }

    public function likes()
    {
        return $this->morphMany(Like::class, 'target');
    }

    public function moderationLogs()
    {
        return $this->hasMany(ModerationLog::class);
    }

    public function latestModeration()
    {
        return $this->hasOne(ModerationLog::class)->latest('created_at');
    }
}
