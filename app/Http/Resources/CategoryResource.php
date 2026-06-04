<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CategoryResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'slug' => $this->slug,
            'description' => $this->description,
            'parent_id' => $this->parent_id,
            'created_at' => $this->created_at,
            'children' => CategoryResource::collection($this->whenLoaded('children')),
            'posts_count' => (int) ($this->posts_count ?? 0),
        ];
    }
}
