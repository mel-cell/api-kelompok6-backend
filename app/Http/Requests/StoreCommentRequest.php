<?php

namespace App\Http\Requests;

use App\Models\Comment;

class StoreCommentRequest extends ApiRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'body' => ['required', 'string'],
            'parent_id' => ['nullable', 'string', 'exists:comments,id', function ($attr, $value, $fail) {
                if ($value) {
                    $parent = Comment::find($value);
                    if ($parent && $parent->parent_id !== null) {
                        $fail('Tidak dapat membalas komentar yang sudah merupakan balasan.');
                    }
                }
            }],
        ];
    }
}
