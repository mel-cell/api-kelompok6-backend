<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreReportRequest;
use App\Http\Resources\ReportResource;
use App\Models\Report;
use App\Models\User;
use App\Notifications\ReportCreatedNotification;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Notification;
use Illuminate\Validation\ValidationException;
use OpenApi\Attributes as OA;

class ReportController extends Controller
{
    #[OA\Get(
        path: '/api/v1/reports/reasons',
        summary: 'Daftar alasan report',
        tags: ['Reports']
    )]
    #[OA\Response(
        response: 200,
        description: 'Daftar alasan report',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Berhasil'),
                new OA\Property(property: 'data', type: 'array', items: new OA\Items(
                    properties: [
                        new OA\Property(property: 'value', type: 'string'),
                        new OA\Property(property: 'label', type: 'string'),
                    ]
                )),
            ]
        )
    )]
    public function reasons(): JsonResponse
    {
        try {
            return $this->ok(config('report.reasons'));
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    #[OA\Post(
        path: '/api/v1/reports',
        summary: 'Buat laporan baru',
        security: [['bearerAuth' => []]],
        tags: ['Reports']
    )]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            required: ['target_id', 'target_type', 'reason'],
            properties: [
                new OA\Property(property: 'target_id', type: 'string', format: 'uuid'),
                new OA\Property(property: 'target_type', type: 'string', enum: ['post', 'comment']),
                new OA\Property(property: 'reason', type: 'string'),
                new OA\Property(property: 'description', type: 'string', nullable: true),
            ]
        )
    )]
    #[OA\Response(
        response: 201,
        description: 'Laporan berhasil dikirim',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Laporan berhasil dikirim.'),
                new OA\Property(property: 'data', ref: '#/components/schemas/Report'),
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
    public function store(StoreReportRequest $request): JsonResponse
    {
        try {
            $report = Report::create([
                'reporter_id' => $request->user()->id,
                'target_id' => $request->target_id,
                'target_type' => $request->target_type,
                'reason' => $request->reason,
                'description' => $request->description,
                'status' => 'pending',
                'created_at' => now(),
            ]);

            $mods = User::whereHas('roles', fn ($q) => $q->whereIn('name', ['moderator', 'admin']))->get();
            if ($mods->isNotEmpty()) {
                Notification::send($mods, new ReportCreatedNotification($report));
            }

            return $this->resource(new ReportResource($report->load('reporter:id,username')), 'Laporan berhasil dikirim.', 201);
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    #[OA\Get(
        path: '/api/v1/reports',
        summary: 'Daftar semua laporan (moderator/admin)',
        security: [['bearerAuth' => []]],
        tags: ['Reports']
    )]
    #[OA\Parameter(name: 'status', in: 'query', required: false, schema: new OA\Schema(type: 'string', enum: ['pending', 'resolved', 'dismissed']))]
    #[OA\Parameter(name: 'target_type', in: 'query', required: false, schema: new OA\Schema(type: 'string', enum: ['post', 'comment']))]
    #[OA\Response(
        response: 200,
        description: 'Daftar laporan',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Berhasil'),
                new OA\Property(property: 'data', type: 'array', items: new OA\Items(ref: '#/components/schemas/Report')),
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
    #[OA\Response(
        response: 403,
        description: 'Akses ditolak (bukan moderator/admin)',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Tidak memiliki akses'),
            ]
        )
    )]
    public function index(Request $request): JsonResponse
    {
        try {
            $query = Report::with(['reporter:id,username', 'resolver:id,username']);

            if ($request->filled('status')) {
                $query->where('status', $request->status);
            }

            if ($request->filled('target_type')) {
                $query->where('target_type', $request->target_type);
            }

            $reports = $query->orderBy('created_at', 'desc')->paginate(20);

            return $this->resource(ReportResource::collection($reports));
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    #[OA\Get(
        path: '/api/v1/reports/{id}',
        summary: 'Detail laporan (moderator/admin)',
        security: [['bearerAuth' => []]],
        tags: ['Reports']
    )]
    #[OA\Parameter(name: 'id', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\Response(
        response: 200,
        description: 'Detail laporan',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Berhasil'),
                new OA\Property(property: 'data', ref: '#/components/schemas/Report'),
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
        response: 403,
        description: 'Akses ditolak (bukan moderator/admin)',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Tidak memiliki akses'),
            ]
        )
    )]
    #[OA\Response(
        response: 404,
        description: 'Laporan tidak ditemukan',
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
            $report = Report::with([
                'reporter:id,username',
                'resolver:id,username',
                'target',
            ])->findOrFail($id);

            return $this->resource(new ReportResource($report));
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    #[OA\Patch(
        path: '/api/v1/reports/{id}/resolve',
        summary: 'Selesaikan laporan (moderator/admin)',
        security: [['bearerAuth' => []]],
        tags: ['Reports']
    )]
    #[OA\Parameter(name: 'id', in: 'path', required: true, schema: new OA\Schema(type: 'string', format: 'uuid'))]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            required: ['status'],
            properties: [
                new OA\Property(property: 'status', type: 'string', enum: ['resolved', 'dismissed']),
                new OA\Property(property: 'note', type: 'string', nullable: true),
            ]
        )
    )]
    #[OA\Response(
        response: 200,
        description: 'Laporan berhasil diupdate',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Laporan berhasil diupdate.'),
                new OA\Property(property: 'data', ref: '#/components/schemas/Report'),
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
        response: 403,
        description: 'Akses ditolak (bukan moderator/admin)',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Tidak memiliki akses'),
            ]
        )
    )]
    #[OA\Response(
        response: 404,
        description: 'Laporan tidak ditemukan',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: false),
                new OA\Property(property: 'message', type: 'string', example: 'Data tidak ditemukan'),
            ]
        )
    )]
    public function resolve(Request $request, string $id): JsonResponse
    {
        try {
            $request->validate([
                'status' => 'required|in:resolved,dismissed',
                'note' => 'nullable|string|max:500',
            ]);

            $report = Report::findOrFail($id);

            if ($report->status !== 'pending') {
                return $this->error('Laporan ini sudah selesai.', 422);
            }

            $report->update([
                'status' => $request->status,
                'resolved_by' => $request->user()->id,
                'resolved_at' => now(),
            ]);

            return $this->resource(new ReportResource($report->fresh()->load(['reporter:id,username', 'resolver:id,username'])), 'Laporan berhasil diupdate.');
        } catch (ValidationException $e) {
            throw $e;
        } catch (ModelNotFoundException $e) {
            return $this->notFound();
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }
}
