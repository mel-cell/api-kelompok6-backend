<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class PostTag extends Model
{
    public $incrementing = false;

    protected $keyType = 'string';

    public $timestamps = false;

    protected $fillable = ['id', 'post_id', 'tag_id'];

    protected static function boot(): void
    {
        parent::boot();
        static::creating(fn ($pt) => $pt->id ??= (string) Str::uuid());
    }
}
