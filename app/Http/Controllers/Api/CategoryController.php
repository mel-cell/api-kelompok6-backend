<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\JsonResponse;

class CategoryController extends Controller
{
    public function index(): JsonResponse
    {
        $categories = Category::with('children')
            ->whereNull('parent_id')
            ->withCount('posts')
            ->orderBy('name')
            ->get();

        return response()->json($categories);
    }

    public function show(string $id): JsonResponse
    {
        $category = Category::with('children')
            ->withCount('posts')
            ->findOrFail($id);

        return response()->json($category);
    }
}
