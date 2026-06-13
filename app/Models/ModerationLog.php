<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class ModerationLog extends Model
{
    public $incrementing = false;

    protected $keyType = 'string';

    public $timestamps = false;

    protected $table = 'moderation_logs';

    protected $fillable = [
        'id', 'post_id', 'comment_id', 'moderator_id', 'action', 'reason',
    ];

    protected $casts = [
        'created_at' => 'datetime',
    ];

    protected static function boot(): void
    {
        parent::boot();
        static::creating(fn ($m) => $m->id ??= (string) Str::uuid());
    }

    public function post()
    {
        return $this->belongsTo(Post::class);
    }

    public function comment()
    {
        return $this->belongsTo(Comment::class);
    }

    public function moderator()
    {
        return $this->belongsTo(User::class, 'moderator_id');
    }
}
