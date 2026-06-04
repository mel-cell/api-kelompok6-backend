<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\CategoryResource;
use App\Models\Category;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Cache;
use OpenApi\Attributes as OA;

class CategoryController extends Controller
{
    #[OA\Get(
        path: '/api/v1/categories',
        summary: 'Daftar semua kategori',
        tags: ['Categories']
    )]
    #[OA\Response(
        response: 200,
        description: 'Daftar kategori berhasil diambil',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Berhasil'),
                new OA\Property(property: 'data', type: 'array', items: new OA\Items(ref: '#/components/schemas/Category')),
            ]
        )
    )]
    public function index(): JsonResponse
    {
        try {
            $categories = Cache::remember('categories_all', 3600, function () {
                return Category::with('children')
                    ->whereNull('parent_id')
                    ->withCount('posts')
                    ->orderBy('name')
                    ->get();
            });

            return $this->resource(CategoryResource::collection($categories));
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    #[OA\Get(
        path: '/api/v1/categories/{id}',
        summary: 'Detail kategori',
        tags: ['Categories']
    )]
    #[OA\Parameter(name: 'id', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\Response(
        response: 200,
        description: 'Detail kategori berhasil diambil',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Berhasil'),
                new OA\Property(property: 'data', ref: '#/components/schemas/Category'),
            ]
        )
    )]
    #[OA\Response(
        response: 404,
        description: 'Kategori tidak ditemukan',
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
            $category = Cache::remember("category_{$id}", 3600, function () use ($id) {
                return Category::with('children')
                    ->withCount('posts')
                    ->findOrFail($id);
            });

            return $this->resource(new CategoryResource($category));
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }
}
