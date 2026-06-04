<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ReportResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'target_id' => $this->target_id,
            'target_type' => $this->target_type,
            'reason' => $this->reason,
            'description' => $this->description,
            'status' => $this->status,
            'created_at' => $this->created_at,
            'resolved_at' => $this->resolved_at,
            'reporter' => new UserResource($this->whenLoaded('reporter')),
            'resolver' => new UserResource($this->whenLoaded('resolver')),
        ];
    }
}
