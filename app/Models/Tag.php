<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Tag extends Model
{
    public $incrementing = false;

    protected $keyType = 'string';

    public $timestamps = false;

    protected $fillable = ['id', 'name', 'slug', 'color', 'usage_count'];

    protected static function boot(): void
    {
        parent::boot();
        static::creating(fn ($tag) => $tag->id ??= (string) Str::uuid());
    }

    public function posts()
    {
        return $this->belongsToMany(Post::class, 'post_tags');
    }
}
