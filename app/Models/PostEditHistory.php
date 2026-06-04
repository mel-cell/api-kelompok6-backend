<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class PostEditHistory extends Model
{
    protected $table = 'post_edit_history';

    public $incrementing = false;

    protected $keyType = 'string';

    public $timestamps = false;

    protected $fillable = ['id', 'post_id', 'edited_by', 'body_before', 'body_after', 'reason'];

    protected static function boot(): void
    {
        parent::boot();
        static::creating(fn ($h) => $h->id ??= (string) Str::uuid());
    }

    public function post()
    {
        return $this->belongsTo(Post::class);
    }

    public function editor()
    {
        return $this->belongsTo(User::class, 'edited_by');
    }
}
