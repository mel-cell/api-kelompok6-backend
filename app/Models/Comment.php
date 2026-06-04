<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;
use Laravel\Scout\Searchable;

class Comment extends Model
{
    use Searchable;

    public $incrementing = false;

    protected $keyType = 'string';

    protected $fillable = [
        'post_id', 'user_id', 'parent_id', 'body',
        'vote_score', 'is_accepted',
    ];

    protected function casts(): array
    {
        return [
            'is_accepted' => 'boolean',
        ];
    }

    protected static function boot(): void
    {
        parent::boot();
        static::creating(fn ($c) => $c->id ??= (string) Str::uuid());
    }

    public function post()
    {
        return $this->belongsTo(Post::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function parent()
    {
        return $this->belongsTo(Comment::class, 'parent_id');
    }

    public function replies()
    {
        return $this->hasMany(Comment::class, 'parent_id');
    }

    public function editHistories()
    {
        return $this->hasMany(CommentEditHistory::class);
    }
}
