<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('likes', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignUuid('user_id')->constrained()->cascadeOnDelete();
            $table->uuid('target_id');
            $table->string('target_type', 20);
            $table->timestamp('created_at')->useCurrent();

            $table->unique(['user_id', 'target_id', 'target_type']);
            $table->index(['target_id', 'target_type']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('likes');
    }
};
