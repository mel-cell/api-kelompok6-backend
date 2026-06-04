<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\TagResource;
use App\Models\Tag;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Cache;
use OpenApi\Attributes as OA;

class TagController extends Controller
{
    #[OA\Get(
        path: '/api/v1/tags',
        summary: 'Daftar semua tag',
        tags: ['Tags']
    )]
    #[OA\Response(
        response: 200,
        description: 'Daftar tag berhasil diambil',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Berhasil'),
                new OA\Property(property: 'data', type: 'array', items: new OA\Items(ref: '#/components/schemas/Tag')),
            ]
        )
    )]
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

    #[OA\Get(
        path: '/api/v1/tags/{id}',
        summary: 'Detail tag',
        tags: ['Tags']
    )]
    #[OA\Parameter(name: 'id', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\Response(
        response: 200,
        description: 'Detail tag berhasil diambil',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Berhasil'),
                new OA\Property(property: 'data', ref: '#/components/schemas/Tag'),
            ]
        )
    )]
    #[OA\Response(
        response: 404,
        description: 'Tag tidak ditemukan',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Data tidak ditemukan'),
            ]
        )
    )]
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
