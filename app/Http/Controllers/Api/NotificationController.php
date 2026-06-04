<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\NotificationResource;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use OpenApi\Attributes as OA;

class NotificationController extends Controller
{
    #[OA\Get(
        path: '/api/v1/notifications',
        summary: 'Daftar notifikasi user',
        security: [['bearerAuth' => []]],
        tags: ['Notifications']
    )]
    #[OA\Parameter(name: 'per_page', in: 'query', required: false, schema: new OA\Schema(type: 'integer', default: 20))]
    #[OA\Response(
        response: 200,
        description: 'Daftar notifikasi'
    )]
    #[OA\Response(
        response: 401,
        description: 'Tidak terautentikasi'
    )]
    public function index(Request $request): JsonResponse
    {
        try {
            $notifications = $request->user()->notifications()
                ->orderBy('created_at', 'desc')
                ->paginate($request->per_page ?? 20);

            return $this->resource(NotificationResource::collection($notifications));
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    #[OA\Patch(
        path: '/api/v1/notifications/{id}/read',
        summary: 'Tandai satu notifikasi telah dibaca',
        security: [['bearerAuth' => []]],
        tags: ['Notifications']
    )]
    #[OA\Parameter(name: 'id', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\Response(
        response: 200,
        description: 'Notifikasi ditandai dibaca'
    )]
    #[OA\Response(
        response: 401,
        description: 'Tidak terautentikasi'
    )]
    #[OA\Response(
        response: 404,
        description: 'Notifikasi tidak ditemukan'
    )]
    public function markRead(Request $request, string $id): JsonResponse
    {
        try {
            $notification = $request->user()->notifications()->findOrFail($id);
            $notification->markAsRead();

            return $this->ok(null, 'Notifikasi ditandai dibaca');
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    #[OA\Patch(
        path: '/api/v1/notifications/read-all',
        summary: 'Tandai semua notifikasi telah dibaca',
        security: [['bearerAuth' => []]],
        tags: ['Notifications']
    )]
    #[OA\Response(
        response: 200,
        description: 'Semua notifikasi ditandai dibaca'
    )]
    #[OA\Response(
        response: 401,
        description: 'Tidak terautentikasi'
    )]
    public function markAllRead(Request $request): JsonResponse
    {
        try {
            $request->user()->unreadNotifications->markAsRead();

            return $this->ok(null, 'Semua notifikasi ditandai dibaca');
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    #[OA\Get(
        path: '/api/v1/notifications/unread-count',
        summary: 'Jumlah notifikasi belum dibaca',
        security: [['bearerAuth' => []]],
        tags: ['Notifications']
    )]
    #[OA\Response(
        response: 200,
        description: 'Jumlah notifikasi belum dibaca'
    )]
    #[OA\Response(
        response: 401,
        description: 'Tidak terautentikasi'
    )]
    public function unreadCount(Request $request): JsonResponse
    {
        try {
            $count = $request->user()->unreadNotifications()->count();

            return $this->ok(['unread_count' => $count]);
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }
}
