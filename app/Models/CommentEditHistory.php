<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class CommentEditHistory extends Model
{
    protected $table = 'comment_edit_history';

    public $incrementing = false;

    protected $keyType = 'string';

    public $timestamps = false;

    protected $fillable = ['id', 'comment_id', 'edited_by', 'body_before', 'body_after'];

    protected static function boot(): void
    {
        parent::boot();
        static::creating(fn ($h) => $h->id ??= (string) Str::uuid());
    }

    public function comment()
    {
        return $this->belongsTo(Comment::class);
    }

    public function editor()
    {
        return $this->belongsTo(User::class, 'edited_by');
    }
}
