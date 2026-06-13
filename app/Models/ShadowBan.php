<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class ShadowBan extends Model
{
    public $incrementing = false;

    protected $keyType = 'string';

    public $timestamps = false;

    protected $table = 'shadow_bans';

    protected $fillable = [
        'id', 'user_id', 'reason', 'restriction_type',
        'restriction_duration', 'expires_at', 'created_by',
    ];

    protected $casts = [
        'expires_at' => 'datetime',
        'created_at' => 'datetime',
    ];

    protected static function boot(): void
    {
        parent::boot();
        static::creating(fn ($m) => $m->id ??= (string) Str::uuid());
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function creator()
    {
        return $this->belongsTo(User::class, 'created_by');
    }
}
