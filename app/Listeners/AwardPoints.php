<?php

namespace App\Listeners;

use App\Events\AnswerAccepted;
use App\Events\CommentCreated;
use App\Events\PostCreated;
use App\Events\VoteCast;
use App\Models\PointsLog;
use App\Models\User;
use Illuminate\Contracts\Queue\ShouldQueue;

class AwardPoints implements ShouldQueue
{
    protected function award(User $user, int $points, string $action, ?string $referenceId = null, ?string $description = null): void
    {
        PointsLog::create([
            'user_id' => $user->id,
            'points' => $points,
            'action_type' => $action,
            'reference_id' => $referenceId,
            'description' => $description,
        ]);

        $user->increment('reputation_points', $points);
        $user->level = $this->calculateLevel($user->fresh()->reputation_points);
        $user->save();
    }

    protected function calculateLevel(int $points): int
    {
        return match (true) {
            $points >= 1000 => 5,
            $points >= 600 => 4,
            $points >= 300 => 3,
            $points >= 100 => 2,
            default => 1,
        };
    }

    public function handle(PostCreated|CommentCreated|AnswerAccepted|VoteCast $event): void
    {
        match (true) {
            $event instanceof PostCreated => $this->award(
                $event->post->user, 10, 'post_created', $event->post->id, 'Membuat post baru'
            ),
            $event instanceof CommentCreated => $this->award(
                $event->comment->user, 5, 'comment_created', $event->comment->id, 'Menambahkan komentar'
            ),
            $event instanceof AnswerAccepted => $this->award(
                $event->comment->user, 20, 'answer_accepted', $event->comment->id, 'Jawaban diterima'
            ),
            $event instanceof VoteCast => $this->award(
                $event->targetOwner, $event->pointsDelta, $event->actionType, $event->referenceId, null
            ),
        };
    }
}
