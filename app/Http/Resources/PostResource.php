<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class PostResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'body' => $this->body,
            'slug' => $this->slug,
            'status' => $this->status,
            'vote_score' => (int) $this->vote_score,
            'view_count' => (int) $this->view_count,
            'is_answered' => (bool) $this->is_answered,
            'accepted_answer_id' => $this->accepted_answer_id,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
            'user' => new UserResource($this->whenLoaded('user')),
            'category' => new CategoryResource($this->whenLoaded('category')),
            'tags' => TagResource::collection($this->whenLoaded('tags')),
            'comments' => CommentResource::collection($this->whenLoaded('comments')),
            'accepted_answer' => new CommentResource($this->whenLoaded('acceptedAnswer')),
            'comments_count' => (int) ($this->comments_count ?? 0),
            'bookmarks_count' => (int) ($this->bookmarks_count ?? 0),
            'user_vote' => $this->user_vote ?? null,
            'user_liked' => (bool) ($this->user_liked ?? false),
            'is_bookmarked' => (bool) ($this->is_bookmarked ?? false),
        ];
    }
}
