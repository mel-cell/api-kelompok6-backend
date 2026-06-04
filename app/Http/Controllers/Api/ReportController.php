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

class ReportController extends Controller
{
    public function reasons(): JsonResponse
    {
        try {
            return $this->ok(config('report.reasons'));
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

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
