<?php

namespace App\Http\Requests;

class UpdatePostRequest extends ApiRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'title' => ['sometimes', 'string', 'max:300'],
            'body' => ['sometimes', 'string'],
            'category_id' => ['sometimes', 'string', 'exists:categories,id'],
            'tags' => ['nullable', 'array'],
            'tags.*' => ['string', 'exists:tags,id'],
        ];
    }
}
