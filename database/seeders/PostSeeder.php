<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Comment;
use App\Models\Post;
use App\Models\Tag;
use App\Models\User;
use Illuminate\Database\Seeder;

class PostSeeder extends Seeder
{
    public function run(): void
    {
        $users = User::all();
        $categories = Category::all();
        $tags = Tag::all();

        $postsData = [
            [
                'title' => 'Cara optimal menggunakan Eloquent Relationships di Laravel 11',
                'body' => "Saya baru belajar Laravel 11 dan bingung cara terbaik menggunakan Eloquent Relationships.\n\nMisalnya, saya punya model `Post` dan `Comment`. Kapan harus pakai `hasMany`, `belongsTo`, atau `morphMany`? Ada best practice untuk performa?\n\nMohon pencerahan dari teman-teman yang sudah berpengalaman.",
                'category_id' => 1, 'tags' => ['php', 'laravel'],
            ],
            [
                'title' => 'Best practice REST API response structure',
                'body' => "Saya sedang membangun REST API dan ingin tahu struktur response JSON yang baik.\n\n1. Haruskah pakai envelope seperti `{ data: ..., message: ... }`?\n2. Kapan pakai HTTP code 200 vs 201?\n3. Apakah perlu menyertakan pagination metadata?\n\nTolong share pengalaman kalian!",
                'category_id' => 1, 'tags' => ['rest-api'],
            ],
            [
                'title' => 'React useState vs useReducer, kapan pake yang mana?',
                'body' => "Saya masih bingung kapan harus menggunakan `useState` dan kapan `useReducer`.\n\nDari yang saya baca:\n- `useState` untuk state sederhana\n- `useReducer` untuk state kompleks dengan banyak action\n\nTapi di praktiknya, state sederhana pun kadang butuh banyak setter. Mohon saran!",
                'category_id' => 2, 'tags' => ['typescript', 'react'],
            ],
            [
                'title' => 'Tips debugging memory leak di Node.js',
                'body' => "Aplikasi Node.js saya mengalami memory leak setelah berjalan beberapa jam.\n\nSudah coba:\n- Heap snapshot\n- Chrome DevTools\n- `--inspect` flag\n\nTapi masih belum ketemu sumbernya. Ada tools atau teknik lain yang bisa dicoba?",
                'category_id' => 2, 'tags' => ['javascript', 'rest-api'],
            ],
            [
                'title' => 'Perbedaan Docker Compose vs Kubernetes untuk development',
                'body' => "Tim saya sedang diskusi tentang container orchestration.\n\nSelama ini pakai Docker Compose untuk local development. Tapi ada yang usul pindah ke Kubernetes.\n\nApa kelebihan dan kekurangan masing-masing untuk development workflow sehari-hari?",
                'category_id' => 6, 'tags' => ['docker', 'rest-api'],
            ],
            [
                'title' => 'Cara migrate dari MySQL ke PostgreSQL',
                'body' => "Kami berencana migrate database dari MySQL ke PostgreSQL.\n\nYang perlu dipertimbangkan:\n1. Perbedaan tipe data\n2. Migration tools yang tersedia\n3. Downtime strategy\n4. Testing parity\n\nAda yang punya pengalaman migrasi serupa?",
                'category_id' => 5, 'tags' => ['mysql', 'postgresql'],
            ],
            [
                'title' => 'Python type hints untuk production code',
                'body' => "Saya mulai pakai Python type hints di project production. Tapi kadang ragu:\n\n- Seberapa strict harusnya?\n- `List[int]` vs `Sequence[int]`?\n- Harus pakai `Optional` atau `| None`?\n- Overhead development time vs benefit?\n\nShare pengalaman kalian dong!",
                'category_id' => 1, 'tags' => ['python', 'rest-api'],
            ],
            [
                'title' => 'Tailwind CSS vs CSS Modules untuk project besar',
                'body' => "Tim saya diskusi tentang CSS approach.\n\nTim A: Tailwind lebih cepat development, utility-first\nTim B: CSS Modules lebih terstruktur, maintainable\n\nAda yang punya pengalaman pakai Tailwind di project besar (>50 komponen)?",
                'category_id' => 4, 'tags' => ['tailwind-css'],
            ],
            [
                'title' => 'Strategi caching Redis untuk aplikasi high-traffic',
                'body' => "Aplikasi kami mulai mengalami traffic tinggi dan perlu caching strategy.\n\nRencana:\n1. Cache query results (Redis)\n2. Full page cache untuk pages statis\n3. Queue untuk background jobs\n\nAda best practice atau gotcha yang harus diwaspadai?",
                'category_id' => 6, 'tags' => ['redis', 'rest-api'],
            ],
            [
                'title' => 'Belajar AI/ML dari nol, mulai dari mana?',
                'body' => "Saya ingin belajar AI/ML tapi bingung mulai dari mana.\n\nBackground: full-stack developer (PHP/JS).\n\nRencana belajar:\n1. Python basics\n2. NumPy & Pandas\n3. Scikit-learn\n4. TensorFlow/PyTorch\n\nApakah urutan ini sudah benar? Ada sumber belajar yang recommended?",
                'category_id' => 7, 'tags' => ['python'],
            ],
        ];

        foreach ($postsData as $i => $data) {
            $user = $users[$i % count($users)];
            $category = $categories[$data['category_id'] - 1] ?? $categories->first();

            $post = Post::create([
                'user_id' => $user->id,
                'category_id' => $category->id,
                'title' => $data['title'],
                'body' => $data['body'],
                'vote_score' => rand(-5, 20),
            ]);

            $tagIds = Tag::whereIn('slug', $data['tags'])->pluck('id')->toArray();
            $post->tags()->attach($tagIds);

            $numComments = rand(1, 4);
            for ($c = 0; $c < $numComments; $c++) {
                $commentUser = $users[($i + $c + 1) % count($users)];
                $comment = Comment::create([
                    'user_id' => $commentUser->id,
                    'post_id' => $post->id,
                    'body' => $this->getRandomComment(),
                    'vote_score' => rand(-2, 10),
                ]);

                if (rand(0, 1) && $c < 2) {
                    Comment::create([
                        'user_id' => $users[($i + $c + 2) % count($users)]->id,
                        'post_id' => $post->id,
                        'parent_id' => $comment->id,
                        'body' => 'Setuju dengan pendapat kamu. Saya juga mengalami hal yang sama.',
                        'vote_score' => rand(0, 5),
                    ]);
                }
            }

        }
    }

    private function getRandomComment(): string
    {
        $comments = [
            'Pengalaman saya pribadi, mending pelajari konsep dasarnya dulu sebelum masuk ke framework.',
            'Saya dulu juga bingung, tapi setelah baca dokumentasi resmi jadi lebih paham.',
            'Artikel yang bagus! Saya setuju dengan poin-poin yang disampaikan.',
            'Kalau menurut saya, tergantung use case masing-masing. Tidak ada solusi satu ukuran untuk semua.',
            'Saya punya pengalaman berbeda. Menurut saya, yang terpenting adalah konsistensi tim.',
            'Terima kasih sudah berbagi. Sangat membantu!',
            'Ada baiknya juga dipertimbangkan faktor keamanan dalam implementasinya.',
            'Saya recommend cek repo GitHub berikut untuk referensi implementasi.',
            'Jangan lupa pertimbangkan aspek scalability ketika memilih approach.',
            'Saya sudah menggunakan approach ini di production selama 6 bulan, dan works well.',
        ];

        return $comments[array_rand($comments)];
    }
}
