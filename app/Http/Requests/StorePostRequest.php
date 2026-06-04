<?php

namespace App\Http\Requests;

class StorePostRequest extends ApiRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'title' => ['required', 'string', 'max:300'],
            'body' => ['required', 'string'],
            'category_id' => ['required', 'string', 'exists:categories,id'],
            'tags' => ['nullable', 'array'],
            'tags.*' => ['string', 'exists:tags,id'],
        ];
    }
}
