<?php

namespace App\Http\Controllers;

use App\Traits\ApiResponse;
use OpenApi\Attributes as OA;

#[OA\Info(
    title: 'API Kelompok 6',
    version: '1.0.0',
    description: 'Dokumentasi API Kelompok 6 dengan standar keamanan OWASP'
)]
#[OA\Server(
    url: L5_SWAGGER_CONST_HOST,
    description: 'API Server Utama'
)]
#[OA\SecurityScheme(
    securityScheme: 'bearerAuth',
    type: 'http',
    scheme: 'bearer',
    bearerFormat: 'JWT'
)]
abstract class Controller
{
    use ApiResponse;
}
