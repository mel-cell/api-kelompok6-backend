<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Comment;
use App\Models\PageView;
use App\Models\Post;
use App\Models\Report;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        try {
            $range = min((int) $request->query('range', '7'), 90);
            $range = max($range, 1);

            $stats = $this->getStats();
            $peakHour = $this->getPeakHour();
            $activeToday = $this->getActiveToday();
            $trafficData = $this->getTrafficData($range);
            $reportsData = $this->getReportsData($range);
            $overviewData = $this->getOverviewData($range);
            $recentActivity = $this->getRecentActivity();

            return $this->ok([
                'stats' => $stats,
                'peakHour' => $peakHour,
                'activeToday' => $activeToday,
                'trafficData' => $trafficData,
                'reportsData' => $reportsData,
                'overviewData' => $overviewData,
                'recentActivity' => $recentActivity,
            ]);
        } catch (\Throwable $e) {
            return $this->error('Terjadi kesalahan server', 500);
        }
    }

    private function getStats(): array
    {
        $today = now()->startOfDay();
        $yesterday = now()->subDay()->startOfDay();

        $activeToday = PageView::where('visited_at', '>=', $today)
            ->distinct('session_id')
            ->count('session_id');

        $activeYesterday = PageView::whereBetween('visited_at', [$yesterday, $today])
            ->distinct('session_id')
            ->count('session_id');

        $newUsersToday = User::where('created_at', '>=', $today)->count();
        $newUsersYesterday = User::whereBetween('created_at', [$yesterday, $today])->count();

        $sessionData = PageView::where('visited_at', '>=', $today)
            ->select('session_id',
                DB::raw('MIN(visited_at) as first_visit'),
                DB::raw('MAX(visited_at) as last_visit'),
                DB::raw('COUNT(*) as views_count'))
            ->groupBy('session_id')
            ->get();

        $totalSessions = $sessionData->count();
        $bouncedSessions = $sessionData->where('views_count', 1)->count();
        $totalDuration = 0;
        $durationSessions = 0;

        foreach ($sessionData as $s) {
            $first = $s->first_visit instanceof \DateTimeInterface ? $s->first_visit : new Carbon($s->first_visit);
            $last = $s->last_visit instanceof \DateTimeInterface ? $s->last_visit : new Carbon($s->last_visit);
            $diff = $last->diffInSeconds($first);
            if ($diff > 0) {
                $totalDuration += $diff;
                $durationSessions++;
            }
        }

        $avgDuration = $durationSessions > 0 ? round($totalDuration / $durationSessions) : 0;
        $bounceRate = $totalSessions > 0 ? round(($bouncedSessions / $totalSessions) * 100, 1) : 0;

        $activeChange = $this->pctChange($activeToday, $activeYesterday);
        $newUsersChange = $this->pctChange($newUsersToday, $newUsersYesterday);

        $avgDurationYesterday = $this->getAvgDuration($yesterday, $today);
        $avgDurationChange = $this->pctChange($avgDuration, $avgDurationYesterday);

        $bounceRateYesterday = $this->getBounceRate($yesterday, $today);
        $bounceRateChange = $this->pctChange($bounceRate, $bounceRateYesterday);

        $fmtDuration = $avgDuration > 0
            ? floor($avgDuration / 60).'m '.($avgDuration % 60).'s'
            : '0m 0s';

        return [
            ['label' => 'Active Today', 'value' => number_format($activeToday, 0, ',', '.'), 'change' => $activeChange, 'icon' => 'users'],
            ['label' => 'New Session', 'value' => number_format($newUsersToday, 0, ',', '.'), 'change' => $newUsersChange, 'icon' => 'activity'],
            ['label' => 'Avg. Duration', 'value' => $fmtDuration, 'change' => $avgDurationChange, 'icon' => 'clock'],
            ['label' => 'Bounce Rate', 'value' => number_format($bounceRate, 1, ',', '.').'%', 'change' => $bounceRateChange, 'icon' => 'trending-down'],
        ];
    }

    private function getAvgDuration(Carbon $start, Carbon $end): int
    {
        $sessions = PageView::whereBetween('visited_at', [$start, $end])
            ->select('session_id',
                DB::raw('MIN(visited_at) as first_visit'),
                DB::raw('MAX(visited_at) as last_visit'),
                DB::raw('COUNT(*) as views_count'))
            ->groupBy('session_id')
            ->get();

        $total = 0;
        $count = 0;
        foreach ($sessions as $s) {
            $first = $s->first_visit instanceof \DateTimeInterface ? $s->first_visit : new Carbon($s->first_visit);
            $last = $s->last_visit instanceof \DateTimeInterface ? $s->last_visit : new Carbon($s->last_visit);
            $diff = $last->diffInSeconds($first);
            if ($diff > 0) {
                $total += $diff;
                $count++;
            }
        }

        return $count > 0 ? round($total / $count) : 0;
    }

    private function getBounceRate(Carbon $start, Carbon $end): float
    {
        $sessions = PageView::whereBetween('visited_at', [$start, $end])
            ->select('session_id', DB::raw('COUNT(*) as views_count'))
            ->groupBy('session_id')
            ->get();

        $total = $sessions->count();
        $bounced = $sessions->where('views_count', 1)->count();

        return $total > 0 ? round(($bounced / $total) * 100, 1) : 0;
    }

    private function getPeakHour(): string
    {
        $today = now()->startOfDay();

        $hour = PageView::where('visited_at', '>=', $today)
            ->select(DB::raw('HOUR(visited_at) as hour'), DB::raw('COUNT(*) as total'))
            ->groupBy('hour')
            ->orderByDesc('total')
            ->first();

        if (! $hour) {
            return 'Belum ada data';
        }

        $start = str_pad($hour->hour, 2, '0', STR_PAD_LEFT).'.00';
        $end = str_pad(($hour->hour + 1) % 24, 2, '0', STR_PAD_LEFT).'.00';

        return "$start \u{2013} $end";
    }

    private function getActiveToday(): int
    {
        return PageView::where('visited_at', '>=', now()->startOfDay())
            ->distinct('session_id')
            ->count('session_id');
    }

    private function getTrafficData(int $range): array
    {
        $start = now()->subDays($range - 1)->startOfDay();

        $rows = PageView::where('visited_at', '>=', $start)
            ->select(DB::raw('DATE(visited_at) as date'), DB::raw('COUNT(DISTINCT session_id) as value'))
            ->groupBy(DB::raw('DATE(visited_at)'))
            ->orderBy('date')
            ->get()
            ->keyBy('date');

        return $this->fillDateRange($start, now(), $rows, 'value', 0);
    }

    private function getReportsData(int $range): array
    {
        $start = now()->subDays($range - 1)->startOfDay();

        $rows = Report::where('created_at', '>=', $start)
            ->select(DB::raw('DATE(created_at) as date'), DB::raw('COUNT(*) as value'))
            ->groupBy(DB::raw('DATE(created_at)'))
            ->orderBy('date')
            ->get()
            ->keyBy('date');

        return $this->fillDateRange($start, now(), $rows, 'value', 0);
    }

    private function getOverviewData(int $range): array
    {
        $start = now()->subDays($range - 1)->startOfDay();

        $users = User::where('created_at', '>=', $start)
            ->select(DB::raw('DATE(created_at) as date'), DB::raw('COUNT(*) as total'))
            ->groupBy(DB::raw('DATE(created_at)'))
            ->get()
            ->keyBy('date');

        $posts = Post::where('created_at', '>=', $start)
            ->select(DB::raw('DATE(created_at) as date'), DB::raw('COUNT(*) as total'))
            ->groupBy(DB::raw('DATE(created_at)'))
            ->get()
            ->keyBy('date');

        $comments = Comment::where('created_at', '>=', $start)
            ->select(DB::raw('DATE(created_at) as date'), DB::raw('COUNT(*) as total'))
            ->groupBy(DB::raw('DATE(created_at)'))
            ->get()
            ->keyBy('date');

        $result = [];
        $end = now();
        $current = $start->copy();

        while ($current->lte($end)) {
            $key = $current->format('Y-m-d');
            $result[] = [
                'date' => $current->locale('id')->isoFormat('D MMM'),
                'users' => (int) ($users[$key]->total ?? 0),
                'posts' => (int) ($posts[$key]->total ?? 0),
                'comments' => (int) ($comments[$key]->total ?? 0),
            ];
            $current->addDay();
        }

        return $result;
    }

    private function getRecentActivity(): array
    {
        $activities = [];

        $newUsers = User::latest('created_at')->take(5)->get();
        foreach ($newUsers as $u) {
            $activities[] = [
                'id' => 'u-'.$u->id,
                'user' => $u->username,
                'action' => 'Mendaftar akun baru',
                'time' => $u->created_at->diffForHumans(),
                'avatar' => $this->getInitials($u->username),
            ];
        }

        $newPosts = Post::with('user:id,username')->latest('created_at')->take(5)->get();
        foreach ($newPosts as $p) {
            if ($p->user) {
                $activities[] = [
                    'id' => 'p-'.$p->id,
                    'user' => $p->user->username,
                    'action' => 'Membuat postingan baru',
                    'time' => $p->created_at->diffForHumans(),
                    'avatar' => $this->getInitials($p->user->username),
                ];
            }
        }

        $newComments = Comment::with('user:id,username')->latest('created_at')->take(5)->get();
        foreach ($newComments as $c) {
            if ($c->user) {
                $activities[] = [
                    'id' => 'c-'.$c->id,
                    'user' => $c->user->username,
                    'action' => 'Mengomentari diskusi',
                    'time' => $c->created_at->diffForHumans(),
                    'avatar' => $this->getInitials($c->user->username),
                ];
            }
        }

        $newReports = Report::with('reporter:id,username')->latest('created_at')->take(5)->get();
        foreach ($newReports as $r) {
            if ($r->reporter) {
                $activities[] = [
                    'id' => 'r-'.$r->id,
                    'user' => $r->reporter->username,
                    'action' => 'Melaporkan konten',
                    'time' => $r->created_at->diffForHumans(),
                    'avatar' => $this->getInitials($r->reporter->username),
                ];
            }
        }

        usort($activities, fn ($a, $b) => strtotime($b['time']) - strtotime($a['time']));

        return array_slice($activities, 0, 10);
    }

    private function fillDateRange(Carbon $start, Carbon $end, $rows, string $valueKey, mixed $default): array
    {
        $result = [];
        $current = $start->copy();

        while ($current->lte($end)) {
            $key = $current->format('Y-m-d');
            $result[] = [
                'date' => $current->locale('id')->isoFormat('D MMM'),
                'value' => (int) ($rows[$key]->{$valueKey} ?? $default),
            ];
            $current->addDay();
        }

        return $result;
    }

    private function pctChange(int|float $current, int|float $previous): float
    {
        if ($previous == 0) {
            return $current > 0 ? 100 : 0;
        }

        return round((($current - $previous) / $previous) * 100, 1);
    }

    private function getInitials(string $name): string
    {
        $parts = explode(' ', trim($name));
        if (count($parts) >= 2) {
            return strtoupper(substr($parts[0], 0, 1).substr($parts[1], 0, 1));
        }

        return strtoupper(substr($name, 0, 2));
    }
}
