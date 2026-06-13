<?php

namespace App\Notifications;

use App\Models\Report;
use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Notification;

class ReportResolvedNotification extends Notification implements ShouldQueue
{
    use Queueable;

    public function __construct(
        public Report $report,
        public string $outcome,
        public User $resolver,
    ) {
        $this->queue = 'notifications';
    }

    public function via(object $notifiable): array
    {
        return ['database'];
    }

    public function toArray(object $notifiable): array
    {
        return [
            'type' => 'report_resolved',
            'report_id' => $this->report->id,
            'target_id' => $this->report->target_id,
            'target_type' => $this->report->target_type,
            'reason' => $this->report->reason,
            'outcome' => $this->outcome,
            'resolver_id' => $this->resolver->id,
            'resolver_username' => $this->resolver->username,
        ];
    }
}
