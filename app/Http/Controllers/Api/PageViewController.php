<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PageView;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class PageViewController extends Controller
{
    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'session_id' => 'required|string|max:100',
            'url' => 'required|string|max:500',
            'referer' => 'nullable|string|max:500',
        ]);

        try {
            $userId = null;
            if ($request->bearerToken()) {
                try {
                    $user = Auth::guard('sanctum')->user();
                    $userId = $user?->id;
                } catch (\Throwable) {
                }
            }

            PageView::create([
                'session_id' => $request->session_id,
                'url' => $request->url,
                'user_id' => $userId,
                'ip_address' => $request->ip(),
                'user_agent' => $request->userAgent(),
                'referer' => $request->referer,
                'visited_at' => now(),
            ]);

            return $this->noContent();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }
}
