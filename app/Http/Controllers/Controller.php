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
    url: 'https://api.melvin.my.id',
    description: 'API Server Utama'
)]
#[OA\SecurityScheme(
    securityScheme: 'bearerAuth',
    type: 'http',
    scheme: 'bearer',
    bearerFormat: 'JWT'
)]
#[OA\Schema(schema: 'Role', properties: [
    new OA\Property(property: 'id', type: 'string', format: 'uuid'),
    new OA\Property(property: 'name', type: 'string'),
])]
#[OA\Schema(schema: 'User', properties: [
    new OA\Property(property: 'id', type: 'string', format: 'uuid'),
    new OA\Property(property: 'username', type: 'string'),
    new OA\Property(property: 'email', type: 'string', nullable: true),
    new OA\Property(property: 'avatar_url', type: 'string', nullable: true),
    new OA\Property(property: 'bio', type: 'string', nullable: true),
    new OA\Property(property: 'reputation_points', type: 'integer'),
    new OA\Property(property: 'level', type: 'integer'),
    new OA\Property(property: 'created_at', type: 'string', format: 'date-time'),
    new OA\Property(property: 'roles', type: 'array', items: new OA\Items(ref: '#/components/schemas/Role')),
    new OA\Property(property: 'followers_count', type: 'integer'),
    new OA\Property(property: 'following_count', type: 'integer'),
    new OA\Property(property: 'posts_count', type: 'integer'),
])]
#[OA\Schema(schema: 'Category', properties: [
    new OA\Property(property: 'id', type: 'string', format: 'uuid'),
    new OA\Property(property: 'name', type: 'string'),
    new OA\Property(property: 'slug', type: 'string'),
    new OA\Property(property: 'description', type: 'string', nullable: true),
    new OA\Property(property: 'parent_id', type: 'string', format: 'uuid', nullable: true),
    new OA\Property(property: 'created_at', type: 'string', format: 'date-time'),
    new OA\Property(property: 'children', type: 'array', items: new OA\Items(ref: '#/components/schemas/Category')),
    new OA\Property(property: 'posts_count', type: 'integer'),
])]
#[OA\Schema(schema: 'Tag', properties: [
    new OA\Property(property: 'id', type: 'string', format: 'uuid'),
    new OA\Property(property: 'name', type: 'string'),
    new OA\Property(property: 'slug', type: 'string'),
    new OA\Property(property: 'color', type: 'string', nullable: true),
    new OA\Property(property: 'posts_count', type: 'integer'),
])]
#[OA\Schema(schema: 'Comment', properties: [
    new OA\Property(property: 'id', type: 'string', format: 'uuid'),
    new OA\Property(property: 'body', type: 'string'),
    new OA\Property(property: 'vote_score', type: 'integer'),
    new OA\Property(property: 'is_accepted', type: 'boolean'),
    new OA\Property(property: 'created_at', type: 'string', format: 'date-time'),
    new OA\Property(property: 'updated_at', type: 'string', format: 'date-time'),
    new OA\Property(property: 'user', ref: '#/components/schemas/User'),
    new OA\Property(property: 'replies', type: 'array', items: new OA\Items(ref: '#/components/schemas/Comment')),
    new OA\Property(property: 'replies_count', type: 'integer'),
])]
#[OA\Schema(schema: 'Post', properties: [
    new OA\Property(property: 'id', type: 'string', format: 'uuid'),
    new OA\Property(property: 'title', type: 'string'),
    new OA\Property(property: 'body', type: 'string'),
    new OA\Property(property: 'slug', type: 'string'),
    new OA\Property(property: 'status', type: 'string'),
    new OA\Property(property: 'vote_score', type: 'integer'),
    new OA\Property(property: 'view_count', type: 'integer'),
    new OA\Property(property: 'is_answered', type: 'boolean'),
    new OA\Property(property: 'accepted_answer_id', type: 'string', format: 'uuid', nullable: true),
    new OA\Property(property: 'created_at', type: 'string', format: 'date-time'),
    new OA\Property(property: 'updated_at', type: 'string', format: 'date-time'),
    new OA\Property(property: 'user', ref: '#/components/schemas/User'),
    new OA\Property(property: 'category', ref: '#/components/schemas/Category'),
    new OA\Property(property: 'tags', type: 'array', items: new OA\Items(ref: '#/components/schemas/Tag')),
    new OA\Property(property: 'comments', type: 'array', items: new OA\Items(ref: '#/components/schemas/Comment')),
    new OA\Property(property: 'accepted_answer', ref: '#/components/schemas/Comment', nullable: true),
    new OA\Property(property: 'comments_count', type: 'integer'),
    new OA\Property(property: 'bookmarks_count', type: 'integer'),
    new OA\Property(property: 'user_vote', type: 'string', nullable: true),
    new OA\Property(property: 'user_liked', type: 'boolean'),
    new OA\Property(property: 'is_bookmarked', type: 'boolean'),
])]
#[OA\Schema(schema: 'Report', properties: [
    new OA\Property(property: 'id', type: 'string', format: 'uuid'),
    new OA\Property(property: 'target_id', type: 'string', format: 'uuid'),
    new OA\Property(property: 'target_type', type: 'string'),
    new OA\Property(property: 'reason', type: 'string'),
    new OA\Property(property: 'description', type: 'string', nullable: true),
    new OA\Property(property: 'status', type: 'string'),
    new OA\Property(property: 'created_at', type: 'string', format: 'date-time'),
    new OA\Property(property: 'resolved_at', type: 'string', format: 'date-time', nullable: true),
    new OA\Property(property: 'reporter', ref: '#/components/schemas/User'),
    new OA\Property(property: 'resolver', ref: '#/components/schemas/User', nullable: true),
])]
#[OA\Schema(schema: 'Notification', properties: [
    new OA\Property(property: 'id', type: 'string', format: 'uuid'),
    new OA\Property(property: 'type', type: 'string'),
    new OA\Property(property: 'data', type: 'object'),
    new OA\Property(property: 'read_at', type: 'string', format: 'date-time', nullable: true),
    new OA\Property(property: 'created_at', type: 'string', format: 'date-time'),
])]
abstract class Controller
{
    use ApiResponse;

    public const ALLOWED_HTML_TAGS = '<p><br><b><i><u><strong><em><h1><h2><h3><h4><h5><h6><ul><ol><li><blockquote><pre><code><span><div><img><a><hr><table><thead><tbody><tr><th><td>';
}
