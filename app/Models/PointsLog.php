<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class PointsLog extends Model
{
    public $incrementing = false;

    protected $keyType = 'string';

    public $timestamps = false;

    protected $fillable = ['id', 'user_id', 'points', 'action_type', 'reference_id', 'description'];

    protected static function boot(): void
    {
        parent::boot();
        static::creating(fn ($log) => $log->id ??= (string) Str::uuid());
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
