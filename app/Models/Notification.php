<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Notification extends Model
{
    protected $table = 'notifications';

    public $incrementing = false;

    protected $keyType = 'string';

    public $timestamps = false;

    protected $fillable = ['id', 'user_id', 'actor_id', 'type', 'reference_id', 'reference_type', 'is_read'];

    protected function casts(): array
    {
        return ['is_read' => 'boolean'];
    }

    protected static function boot(): void
    {
        parent::boot();
        static::creating(fn ($n) => $n->id ??= (string) Str::uuid());
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function actor()
    {
        return $this->belongsTo(User::class, 'actor_id');
    }
}
