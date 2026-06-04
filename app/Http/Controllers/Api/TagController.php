<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\TagResource;
use App\Models\Tag;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Cache;

class TagController extends Controller
{
    public function index(): JsonResponse
    {
        try {
            $tags = Cache::remember('tags_all', 3600, function () {
                return Tag::orderBy('name')->get();
            });

            return $this->resource(TagResource::collection($tags));
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function show(string $id): JsonResponse
    {
        try {
            $tag = Cache::remember("tag_{$id}", 3600, function () use ($id) {
                return Tag::withCount('posts')->findOrFail($id);
            });

            return $this->resource(new TagResource($tag));
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }
}
