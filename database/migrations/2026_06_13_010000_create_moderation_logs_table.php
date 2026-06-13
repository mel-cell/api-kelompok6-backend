<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('moderation_logs', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignUuid('post_id')->constrained('posts')->cascadeOnDelete();
            $table->foreignUuid('moderator_id')->constrained('users')->cascadeOnDelete();
            $table->string('action', 20);
            $table->text('reason')->nullable();
            $table->timestamp('created_at')->useCurrent();

            $table->index('post_id');
            $table->index('action');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('moderation_logs');
    }
};
