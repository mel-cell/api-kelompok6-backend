<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\TagResource;
use App\Models\Tag;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Validation\ValidationException;
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

    #[OA\Post(
        path: '/api/v1/tags',
        summary: 'Buat tag baru',
        security: [['bearerAuth' => []]],
        tags: ['Tags']
    )]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'name', type: 'string', maxLength: 255, example: 'laravel'),
                new OA\Property(property: 'slug', type: 'string', maxLength: 255, example: 'laravel'),
                new OA\Property(property: 'color', type: 'string', maxLength: 7, nullable: true, example: '#ff2d20'),
            ]
        )
    )]
    #[OA\Response(
        response: 201,
        description: 'Tag berhasil dibuat',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Tag berhasil dibuat'),
                new OA\Property(property: 'data', ref: '#/components/schemas/Tag'),
            ]
        )
    )]
    #[OA\Response(
        response: 401,
        description: 'Tidak terautentikasi',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Tidak terautentikasi'),
            ]
        )
    )]
    #[OA\Response(
        response: 422,
        description: 'Validasi gagal',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Validasi gagal'),
                new OA\Property(property: 'errors', type: 'object'),
            ]
        )
    )]
    public function store(Request $request): JsonResponse
    {
        try {
            $request->validate([
                'name' => 'required|string|max:255',
                'slug' => 'required|string|max:255|unique:tags,slug',
                'color' => 'nullable|string|max:7',
            ]);

            $tag = Tag::create([
                'name' => $request->name,
                'slug' => $request->slug,
                'color' => $request->color ?? '#6366f1',
                'usage_count' => 0,
            ]);

            Cache::forget('tags_all');

            return $this->resource(new TagResource($tag), 'Tag berhasil dibuat', 201);
        } catch (ValidationException $e) {
            throw $e;
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function update(Request $request, string $id): JsonResponse
    {
        try {
            $tag = Tag::findOrFail($id);

            $request->validate([
                'name' => 'sometimes|string|max:255',
                'slug' => 'sometimes|string|max:255|unique:tags,slug,'.$id,
                'color' => 'nullable|string|max:7',
            ]);

            $tag->update($request->only(['name', 'slug', 'color']));

            Cache::forget('tags_all');
            Cache::forget("tag_{$id}");

            return $this->resource(new TagResource($tag->fresh()), 'Tag berhasil diperbarui');
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (ValidationException $e) {
            throw $e;
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function destroy(string $id): JsonResponse
    {
        try {
            $tag = Tag::withCount('posts')->findOrFail($id);

            if ($tag->posts_count > 0) {
                return $this->error('Tag digunakan oleh postingan, tidak bisa dihapus.', 422);
            }

            $tag->delete();

            Cache::forget('tags_all');
            Cache::forget("tag_{$id}");

            return $this->ok(null, 'Tag berhasil dihapus');
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }
}
