<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class SwaggerServerUrl
{
    public function handle(Request $request, Closure $next): Response
    {
        $response = $next($request);

        if ($response->headers->get('Content-Type') === 'application/json') {
            $content = json_decode($response->getContent(), true);

            if (isset($content['servers'])) {
                $scheme = $request->getScheme();
                $host = $request->getHttpHost();
                $content['servers'][0]['url'] = "{$scheme}://{$host}";
                $response->setContent(json_encode($content, JSON_UNESCAPED_SLASHES));
            }
        }

        return $response;
    }
}
