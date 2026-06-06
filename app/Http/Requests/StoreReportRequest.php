<?php

namespace App\Http\Requests;

use App\Models\Comment;
use App\Models\Post;
use App\Models\User;
use Illuminate\Validation\Rule;

class StoreReportRequest extends ApiRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        $validReasons = array_keys(config('report.reasons'));

        return [
            'target_id' => [
                'required', 'string',
                function ($attr, $value, $fail) {
                    $type = $this->input('target_type');
                    $model = match ($type) {
                        'post' => Post::class,
                        'comment' => Comment::class,
                        'user' => User::class,
                        default => null,
                    };
                    if (! $model || ! $model::where('id', $value)->exists()) {
                        $fail("{$type} dengan ID tersebut tidak ditemukan.");
                    }
                },
            ],
            'target_type' => ['required', 'string', Rule::in(['post', 'comment', 'user'])],
            'reason' => ['required', 'string', Rule::in($validReasons)],
            'description' => ['nullable', 'string', 'max:1000'],
        ];
    }
}
