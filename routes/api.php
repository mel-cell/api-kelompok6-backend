<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\CommentController;
use App\Http\Controllers\Api\LikeController;
use App\Http\Controllers\Api\NotificationController;
use App\Http\Controllers\Api\PostController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\ReportController;
use App\Http\Controllers\Api\SearchController;
use App\Http\Controllers\Api\TagController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\VoteController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {
    Route::post('/register', [AuthController::class, 'register'])->middleware('throttle:auth');
    Route::post('/login', [AuthController::class, 'login'])->middleware('throttle:auth');

    Route::middleware(['auth:sanctum', 'throttle:api'])->group(function () {
        Route::post('/logout', [AuthController::class, 'logout']);
        Route::get('/user', [AuthController::class, 'me']);

        Route::get('/profile', [ProfileController::class, 'show']);
        Route::put('/profile', [ProfileController::class, 'update']);
        Route::put('/profile/password', [ProfileController::class, 'updatePassword']);
        Route::delete('/profile/avatar', [ProfileController::class, 'destroyAvatar']);
        Route::delete('/profile', [ProfileController::class, 'destroy']);

        Route::get('/users/by-username/{username}', [UserController::class, 'byUsername']);
        Route::get('/users/{user}', [UserController::class, 'show']);
        Route::post('/users/{user}/follow', [UserController::class, 'toggleFollow']);
        Route::get('/users/{user}/followers', [UserController::class, 'followers']);
        Route::get('/users/{user}/following', [UserController::class, 'following']);

        Route::post('/posts', [PostController::class, 'store']);
        Route::put('/posts/{post}', [PostController::class, 'update']);
        Route::delete('/posts/{post}', [PostController::class, 'destroy']);
        Route::patch('/posts/{post}/accept/{comment}', [PostController::class, 'acceptAnswer']);
        Route::post('/posts/{post}/bookmark', [PostController::class, 'toggleBookmark']);
        Route::get('/posts/{post}/history', [PostController::class, 'history']);
        Route::post('/posts/{post}/appeal', [PostController::class, 'appeal']);

        Route::get('/notifications', [NotificationController::class, 'index']);
        Route::delete('/notifications', [NotificationController::class, 'destroyAll']);
        Route::patch('/notifications/{notification}/read', [NotificationController::class, 'markRead']);
        Route::delete('/notifications/{notification}', [NotificationController::class, 'destroy']);
        Route::patch('/notifications/read-all', [NotificationController::class, 'markAllRead']);
        Route::get('/notifications/unread-count', [NotificationController::class, 'unreadCount']);

        Route::post('/posts/{post}/vote', [VoteController::class, 'togglePost']);
        Route::post('/posts/{post}/like', [LikeController::class, 'togglePost']);
        Route::post('/comments/{comment}/vote', [VoteController::class, 'toggleComment']);
        Route::post('/comments/{comment}/like', [LikeController::class, 'toggleComment']);

        Route::post('/posts/{post}/comments', [CommentController::class, 'store']);
        Route::put('/comments/{comment}', [CommentController::class, 'update']);
        Route::delete('/comments/{comment}', [CommentController::class, 'destroy']);
        Route::get('/comments/{comment}/history', [CommentController::class, 'history']);

        Route::post('/reports', [ReportController::class, 'store'])->middleware('throttle:reports');
    });

    Route::get('/reports/reasons', [ReportController::class, 'reasons']);

    Route::middleware(['auth:sanctum', 'role:moderator,admin', 'throttle:api'])->group(function () {
        Route::get('/users', [UserController::class, 'index']);
        Route::patch('/users/{user}/ban', [UserController::class, 'toggleBan']);
        Route::patch('/users/{user}/shadow-ban', [UserController::class, 'shadowBan']);

        Route::get('/reports', [ReportController::class, 'index']);
        Route::get('/reports/{report}', [ReportController::class, 'show']);
        Route::patch('/reports/{report}/resolve', [ReportController::class, 'resolve']);

        Route::post('/categories', [CategoryController::class, 'store']);
        Route::put('/categories/{category}', [CategoryController::class, 'update']);
        Route::delete('/categories/{category}', [CategoryController::class, 'destroy']);

        Route::put('/tags/{tag}', [TagController::class, 'update']);
        Route::delete('/tags/{tag}', [TagController::class, 'destroy']);

        Route::post('/posts/{post}/moderate', [PostController::class, 'moderate']);
        Route::post('/comments/{comment}/moderate', [CommentController::class, 'moderate']);
    });

    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/tags', [TagController::class, 'store']);
        Route::post('/uploads/image', [UploadController::class, 'image']);
    });

    Route::get('/categories', [CategoryController::class, 'index']);
    Route::get('/categories/{category}', [CategoryController::class, 'show']);
    Route::get('/tags', [TagController::class, 'index']);
    Route::get('/tags/{tag}', [TagController::class, 'show']);

    Route::middleware('auth:sanctum')->group(function () {
        Route::get('/search/posts', [SearchController::class, 'posts']);
        Route::get('/search/comments', [SearchController::class, 'comments']);
        Route::get('/search/users', [SearchController::class, 'users']);
    });

    Route::get('/posts', [PostController::class, 'index']);
    Route::get('/posts/{post}', [PostController::class, 'show']);
    Route::get('/posts/{post}/comments', [CommentController::class, 'index']);
});
