<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('moderation_logs', function (Blueprint $table) {
            $table->foreignUuid('post_id')->nullable()->change();
            $table->foreignUuid('comment_id')->nullable()->after('post_id');
            $table->foreign('comment_id')->references('id')->on('comments')->cascadeOnDelete();
            $table->index('comment_id');
        });
    }

    public function down(): void
    {
        Schema::table('moderation_logs', function (Blueprint $table) {
            $table->dropForeign(['comment_id']);
            $table->dropIndex(['comment_id']);
            $table->dropColumn('comment_id');
            $table->foreignUuid('post_id')->nullable(false)->change();
        });
    }
};
