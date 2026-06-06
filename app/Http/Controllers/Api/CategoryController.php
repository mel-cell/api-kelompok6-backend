<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\CategoryResource;
use App\Models\Category;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;
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

    public function store(Request $request): JsonResponse
    {
        try {
            $request->validate([
                'name' => 'required|string|max:255',
                'slug' => 'required|string|max:255|unique:categories,slug',
                'description' => 'nullable|string|max:1000',
                'parent_id' => 'nullable|string|exists:categories,id',
            ]);

            $category = Category::create([
                'name' => $request->name,
                'slug' => $request->slug,
                'description' => $request->description,
                'parent_id' => $request->parent_id,
            ]);

            Cache::forget('categories_all');

            return $this->resource(new CategoryResource($category->load('children')), 'Kategori berhasil dibuat', 201);
        } catch (ValidationException $e) {
            throw $e;
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    public function update(Request $request, string $id): JsonResponse
    {
        try {
            $category = Category::findOrFail($id);

            $request->validate([
                'name' => 'sometimes|string|max:255',
                'slug' => 'sometimes|string|max:255|unique:categories,slug,' . $id,
                'description' => 'nullable|string|max:1000',
                'parent_id' => 'nullable|string|exists:categories,id',
            ]);

            $category->update($request->only(['name', 'slug', 'description', 'parent_id']));

            Cache::forget('categories_all');
            Cache::forget("category_{$id}");

            return $this->resource(new CategoryResource($category->fresh()->load('children')), 'Kategori berhasil diperbarui');
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
            $category = Category::withCount('posts')->findOrFail($id);

            if ($category->posts_count > 0) {
                return $this->error('Kategori memiliki postingan, tidak bisa dihapus.', 422);
            }

            Category::where('parent_id', $id)->update(['parent_id' => null]);
            $category->delete();

            Cache::forget('categories_all');
            Cache::forget("category_{$id}");

            return $this->ok(null, 'Kategori berhasil dihapus');
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }
}
