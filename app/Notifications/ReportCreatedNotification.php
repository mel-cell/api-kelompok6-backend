<?php

namespace App\Notifications;

use App\Models\Report;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Notification;

class ReportCreatedNotification extends Notification implements ShouldQueue
{
    use Queueable;

    public function __construct(
        public Report $report,
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
            'type' => 'report_created',
            'report_id' => $this->report->id,
            'target_id' => $this->report->target_id,
            'target_type' => $this->report->target_type,
            'reason' => $this->report->reason,
            'description' => $this->report->description,
            'reporter_id' => $this->report->reporter_id,
            'status' => $this->report->status,
        ];
    }
}
