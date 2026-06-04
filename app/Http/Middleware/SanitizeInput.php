<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class SanitizeInput
{
    public function handle(Request $request, Closure $next): Response
    {
        $input = $request->all();

        array_walk_recursive($input, function (&$val) {
            if (is_string($val)) {
                // Remove all HTML tags to prevent XSS injection.
                // Normal plain text and markdown are preserved.
                $val = strip_tags($val);
            }
        });

        $request->merge($input);

        return $next($request);
    }
}
