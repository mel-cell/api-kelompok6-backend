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
        description: 'Daftar notifikasi',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Berhasil'),
                new OA\Property(property: 'data', type: 'array', items: new OA\Items(ref: '#/components/schemas/Notification')),
                new OA\Property(property: 'meta', properties: [
                    new OA\Property(property: 'current_page', type: 'integer'),
                    new OA\Property(property: 'last_page', type: 'integer'),
                    new OA\Property(property: 'per_page', type: 'integer'),
                    new OA\Property(property: 'total', type: 'integer'),
                ]),
                new OA\Property(property: 'links', properties: [
                    new OA\Property(property: 'first', type: 'string'),
                    new OA\Property(property: 'last', type: 'string'),
                    new OA\Property(property: 'prev', type: 'string', nullable: true),
                    new OA\Property(property: 'next', type: 'string', nullable: true),
                ]),
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
        description: 'Notifikasi ditandai dibaca',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Notifikasi ditandai dibaca'),
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
        response: 404,
        description: 'Notifikasi tidak ditemukan',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Data tidak ditemukan'),
            ]
        )
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
        description: 'Semua notifikasi ditandai dibaca',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Semua notifikasi ditandai dibaca'),
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
        description: 'Jumlah notifikasi belum dibaca',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Berhasil'),
                new OA\Property(property: 'data', properties: [
                    new OA\Property(property: 'unread_count', type: 'integer', example: 5),
                ]),
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
    public function unreadCount(Request $request): JsonResponse
    {
        try {
            $count = $request->user()->unreadNotifications()->count();

            return $this->ok(['unread_count' => $count]);
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    #[OA\Delete(
        path: '/api/v1/notifications/{id}',
        summary: 'Hapus satu notifikasi',
        security: [['bearerAuth' => []]],
        tags: ['Notifications']
    )]
    #[OA\Parameter(name: 'id', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\Response(
        response: 200,
        description: 'Notifikasi berhasil dihapus',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Notifikasi berhasil dihapus'),
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
        response: 404,
        description: 'Notifikasi tidak ditemukan',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Data tidak ditemukan'),
            ]
        )
    )]
    public function destroy(Request $request, string $id): JsonResponse
    {
        try {
            $notification = $request->user()->notifications()->findOrFail($id);
            $notification->delete();

            return $this->ok(null, 'Notifikasi berhasil dihapus');
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    #[OA\Delete(
        path: '/api/v1/notifications',
        summary: 'Hapus semua notifikasi user',
        security: [['bearerAuth' => []]],
        tags: ['Notifications']
    )]
    #[OA\Response(
        response: 200,
        description: 'Semua notifikasi berhasil dihapus',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Semua notifikasi berhasil dihapus'),
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
    public function destroyAll(Request $request): JsonResponse
    {
        try {
            $request->user()->notifications()->delete();

            return $this->ok(null, 'Semua notifikasi berhasil dihapus');
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }
}
