<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CommentResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        $user = $request->user();
        $isModerator = $user && $user->roles?->contains(fn ($r) => in_array($r->name, ['admin', 'moderator']));

        return [
            'id' => $this->id,
            'body' => $this->body,
            'vote_score' => (int) $this->vote_score,
            'is_accepted' => (bool) $this->is_accepted,
            'status' => $isModerator ? $this->status : null,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
            'user' => new UserResource($this->whenLoaded('user')),
            'replies' => CommentResource::collection($this->whenLoaded('replies')),
            'replies_count' => (int) ($this->replies_count ?? 0),
        ];
    }
}
