<?php

namespace App\Traits;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Resources\Json\ResourceCollection;

trait ApiResponse
{
    protected function success(mixed $data = null, string $message = 'Berhasil', int $code = 200): JsonResponse
    {
        return response()->json([
            'success' => true,
            'message' => $message,
            'data' => $data,
        ], $code);
    }

    protected function created(mixed $data = null, string $message = 'Data berhasil dibuat'): JsonResponse
    {
        return $this->success($data, $message, 201);
    }

    protected function noContent(string $message = 'Berhasil'): JsonResponse
    {
        return response()->json([
            'success' => true,
            'message' => $message,
        ], 204);
    }

    protected function error(string $message = 'Terjadi kesalahan', int $code = 400, mixed $errors = null): JsonResponse
    {
        $response = [
            'success' => false,
            'message' => $message,
        ];

        if ($errors !== null) {
            $response['errors'] = $errors;
        }

        return response()->json($response, $code);
    }

    protected function notFound(string $message = 'Data tidak ditemukan'): JsonResponse
    {
        return $this->error($message, 404);
    }

    protected function forbidden(string $message = 'Tidak memiliki akses'): JsonResponse
    {
        return $this->error($message, 403);
    }

    protected function unauthorized(string $message = 'Tidak terautentikasi'): JsonResponse
    {
        return $this->error($message, 401);
    }

    protected function validationError(mixed $errors, string $message = 'Validasi gagal'): JsonResponse
    {
        return $this->error($message, 422, $errors);
    }

    protected function ok(mixed $data = null, string $message = 'Berhasil'): JsonResponse
    {
        return $this->success($data, $message, 200);
    }

    protected function resource(mixed $resource, string $message = 'Berhasil', int $code = 200): JsonResponse
    {
        if ($resource instanceof ResourceCollection) {
            $responseData = $resource->response()->getData(true);
            $responseData['success'] = true;
            $responseData['message'] = $message;

            return response()->json($responseData, $code);
        }

        return response()->json([
            'success' => true,
            'message' => $message,
            'data' => $resource,
        ], $code);
    }
}
