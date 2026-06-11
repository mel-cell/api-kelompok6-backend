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
        $newPoints = $user->fresh()->reputation_points;
        $user->level = $this->calculateLevel($newPoints);

        if ($newPoints < -90) {
            $user->is_banned = true;
        } elseif ($user->is_banned && $newPoints >= -90) {
            $user->is_banned = false;
        }

        $user->save();
    }

    protected function calculateLevel(int $points): int
    {
        return match (true) {
            $points >= 3500 => 10,
            $points >= 2500 => 9,
            $points >= 1800 => 8,
            $points >= 1200 => 7,
            $points >= 800 => 6,
            $points >= 500 => 5,
            $points >= 300 => 4,
            $points >= 150 => 3,
            $points >= 50 => 2,
            default => 1,
        };
    }

    public function handle(PostCreated|CommentCreated|AnswerAccepted|VoteCast $event): void
    {
        match (true) {
            $event instanceof PostCreated => $this->award(
                $event->post->user, 2, 'post_created', $event->post->id, 'Membuat post baru'
            ),
            $event instanceof CommentCreated => $this->award(
                $event->comment->user, 1, 'comment_created', $event->comment->id, 'Menambahkan komentar'
            ),
            $event instanceof AnswerAccepted => $this->award(
                $event->comment->user, 15, 'answer_accepted', $event->comment->id, 'Jawaban diterima'
            ),
            $event instanceof VoteCast => $this->award(
                $event->targetOwner, $event->pointsDelta, $event->actionType, $event->referenceId, null
            ),
        };
    }
}
