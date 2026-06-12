<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use OpenApi\Attributes as OA;

class UploadController extends Controller
{
    #[OA\Post(
        path: '/api/v1/uploads/image',
        summary: 'Upload gambar untuk rich text editor',
        security: [['bearerAuth' => []]],
        tags: ['Uploads']
    )]
    #[OA\RequestBody(
        required: true,
        content: new OA\MediaType(
            mediaType: 'multipart/form-data',
            schema: new OA\Schema(
                properties: [
                    new OA\Property(property: 'image', type: 'string', format: 'binary', description: 'File gambar'),
                ]
            )
        )
    )]
    #[OA\Response(
        response: 200,
        description: 'Upload berhasil',
        content: new OA\JsonContent(
            properties: [
                new OA\Property(property: 'success', type: 'boolean', example: true),
                new OA\Property(property: 'message', type: 'string', example: 'Upload berhasil'),
                new OA\Property(property: 'data', properties: [
                    new OA\Property(property: 'url', type: 'string', example: 'https://api.melvin.my.id/storage/uploads/posts/xxx.jpg'),
                ]),
            ]
        )
    )]
    #[OA\Response(response: 401, description: 'Tidak terautentikasi')]
    #[OA\Response(response: 422, description: 'Validasi gagal')]
    public function image(Request $request): JsonResponse
    {
        try {
            $request->validate([
                'image' => ['required', 'image', 'mimes:jpeg,png,jpg,gif,webp', 'max:5120'],
            ]);

            $extension = $request->file('image')->extension();
            $filename = Str::uuid().'.'.$extension;
            $path = $request->file('image')->storeAs('uploads/posts', $filename, 'public');

            if ($path === false) {
                return $this->error('Gagal menyimpan gambar', 500);
            }

            return $this->ok([
                'url' => url('storage/'.$path),
            ], 'Upload berhasil');
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }
}
