# PRD — Forum Diskusi Stack Overflow Style (Level: Medium)

## 1. Tujuan & Lingkup

Membangun REST API forum diskusi berbasis tanya-jawab ala Stack Overflow dengan fitur gamifikasi, notifikasi, dan moderasi. API ini melayani frontend (web/mobile) dengan autentikasi berbasis token (Sanctum).

**Tech Stack:**
- Laravel 11 + PHP 8.2
- MySQL 8 (database utama)
- Redis (cache, queue, broadcasting)
- Laravel Sanctum (auth API token)
- Laravel Horizon (manajemen queue)
- Spatie Laravel Permission (role & permission)
- Spatie Laravel Query Builder (filtering/sorting)
- Laravel Scout (full-text search)
- BeyondCode Laravel WebSockets (real-time notifikasi)
- Predis (Redis client)

---

## 2. Fitur & User Stories

### 👤 Auth & User Management
| ID | Fitur | Detail |
|----|-------|--------|
| A1 | Register | `POST /api/register` — validasi email unique, username unique, kirim verifikasi (opsional) |
| A2 | Login | `POST /api/login` — kirim email+password, balikin token Sanctum |
| A3 | Multi Role | 3 role: `admin`, `moderator`, `user`. Assign via Spatie Permission |
| A4 | Edit Profil | `PUT /api/profile` — ganti avatar (upload file), bio, username |
| A5 | Follow / Unfollow | `POST /api/users/{id}/follow` — toggle follow |
| A6 | Reputation Level | Level naik otomatis berdasarkan poin (lihat Gamifikasi) |

### 📝 Postingan
| ID | Fitur | Detail |
|----|-------|--------|
| P1 | CRUD Post | `GET/POST /api/posts`, `GET/PUT/DELETE /api/posts/{id}` — title, body, category_id |
| P2 | Tag & Kategori | Post wajib punya 1 kategori, bisa multiple tag |
| P3 | Accepted Answer | `PATCH /api/posts/{id}/accept/{commentId}` — tandai jawaban terbaik |
| P4 | Bookmark | `POST /api/posts/{id}/bookmark` — toggle bookmark |
| P5 | Edit History | Tiap update post, simpan body_before → body_after di `post_edit_history` |

### 💬 Komentar & Reply
| ID | Fitur | Detail |
|----|-------|--------|
| C1 | Comment & Reply | `GET/POST /api/posts/{id}/comments`, nested reply pakai `parent_id` |
| C2 | Edit / Hapus | Hanya owner atau moderator/admin yang bisa edit/hapus |
| C3 | Edit History | Tiap update komentar, simpan di `comment_edit_history` |

### ❤️ Interaksi
| ID | Fitur | Detail |
|----|-------|--------|
| I1 | Upvote / Downvote Post | `POST /api/posts/{id}/vote` — type: upvote/downvote, unique per user |
| I2 | Upvote / Downvote Komentar | `POST /api/comments/{id}/vote` |
| I3 | Like Post | `POST /api/posts/{id}/like` — toggle |
| I4 | Like Komentar | `POST /api/comments/{id}/like` — toggle |
| I5 | Filter by Tag/Kategori | `GET /api/posts?filter[tag]=laravel&filter[category]=backend` |

### 🏆 Gamifikasi
| ID | Fitur | Detail |
|----|-------|--------|
| G1 | Point System | Tiap aksi menambah/mengurangi poin, catat di `points_log` |
| G2 | Level Otomatis | Update `users.level` berdasarkan total poin (1-10) |

Aturan poin:
| Aksi | Poin |
|------|------|
| Post diupvote | +10 |
| Komentar diupvote | +5 |
| Jawaban diterima | +15 |
| Post dibuat | +2 |
| Komentar dibuat | +1 |
| Post didownvote | -2 |
| Komentar didownvote | -1 |

Level mapping:
| Level | Min Poin |
|-------|----------|
| 1 | 0 |
| 2 | 50 |
| 3 | 150 |
| 4 | 300 |
| 5 | 500 |
| 6 | 800 |
| 7 | 1200 |
| 8 | 1800 |
| 9 | 2500 |
| 10 | 3500 |

### 🔔 Notifikasi
| ID | Fitur | Detail |
|----|-------|--------|
| N1 | Auto Kirim | Notif saat: reply, like, upvote, follow, answer_accepted |
| N2 | Mark as Read | `PATCH /api/notifications/{id}/read` atau `PUT /api/notifications/read-all` |
| N3 | Real-time | Via WebSocket (pusher/beyondcode) untuk notif langsung |

### 🔍 Pencarian
| ID | Fitur | Detail |
|----|-------|--------|
| S1 | Search Post | `GET /api/posts?search=laravel` — full-text via Scout |
| S2 | Advanced Filter | Filter by tag, kategori, user, status, date range via Query Builder |

### 🚩 Moderasi
| ID | Fitur | Detail |
|----|-------|--------|
| M1 | Report Konten | `POST /api/reports` — report post/komentar/user |
| M2 | Handle Report | `PATCH /api/reports/{id}` — resolve/dismiss, khusus moderator/admin |

---

## 3. Endpoint API

### Auth
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | `/api/register` | Register user baru |
| POST | `/api/login` | Login, return token |
| POST | `/api/logout` | Revoke token |
| GET | `/api/user` | Profile user login |

### Users
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/api/users/{id}` | Detail user + stats |
| PUT | `/api/profile` | Update profil sendiri |
| POST | `/api/users/{id}/follow` | Follow/unfollow |
| GET | `/api/users/{id}/followers` | Daftar follower |
| GET | `/api/users/{id}/following` | Daftar following |

### Posts
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/api/posts` | List post (dengan filter, search, paginate) |
| POST | `/api/posts` | Buat post baru |
| GET | `/api/posts/{id}` | Detail post + comments |
| PUT | `/api/posts/{id}` | Update post |
| DELETE | `/api/posts/{id}` | Hapus post (soft) |
| PATCH | `/api/posts/{id}/accept/{commentId}` | Tandai jawaban terbaik |
| POST | `/api/posts/{id}/bookmark` | Toggle bookmark |
| POST | `/api/posts/{id}/vote` | Upvote/downvote |
| POST | `/api/posts/{id}/like` | Toggle like |
| GET | `/api/posts/{id}/history` | Riwayat edit post |

### Comments
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/api/posts/{id}/comments` | List comments per post |
| POST | `/api/posts/{id}/comments` | Buat comment/reply |
| PUT | `/api/comments/{id}` | Edit comment |
| DELETE | `/api/comments/{id}` | Hapus comment |
| POST | `/api/comments/{id}/vote` | Upvote/downvote |
| POST | `/api/comments/{id}/like` | Toggle like |
| GET | `/api/comments/{id}/history` | Riwayat edit comment |

### Tags & Categories
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/api/tags` | List tags |
| GET | `/api/categories` | List categories (tree) |

### Notifications
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/api/notifications` | List notifikasi user |
| PATCH | `/api/notifications/{id}/read` | Tandai satu notif dibaca |
| PUT | `/api/notifications/read-all` | Tandai semua dibaca |

### Reports
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | `/api/reports` | Buat laporan |
| GET | `/api/reports` | List laporan (admin/moderator) |
| PATCH | `/api/reports/{id}` | Resolve/dismiss laporan |

---

## 4. Database Schema

Berdasarkan `medium.sql` dengan struktur tabel:

- `users` — id (uuid), username, email, password_hash, avatar_url, bio, reputation_points, level, is_banned
- `roles` — id, name, permissions (json)
- `user_roles` — pivot user ↔ role
- `categories` — id, name, slug, description, parent_id (self-referencing)
- `tags` — id, name, slug, color, usage_count
- `posts` — id, user_id, category_id, title, body, status, view_count, vote_score, is_answered, accepted_answer_id
- `post_tags` — pivot post ↔ tag
- `post_edit_history` — id, post_id, edited_by, body_before, body_after, reason
- `comments` — id, post_id, user_id, parent_id (nested), body, vote_score, is_accepted
- `comment_edit_history` — id, comment_id, edited_by, body_before, body_after
- `votes` — id, user_id, target_id, target_type (post/comment), vote_type (upvote/downvote)
- `likes` — id, user_id, target_id, target_type (post/comment)
- `bookmarks` — id, user_id, post_id
- `follows` — id, follower_id, following_id
- `points_log` — id, user_id, points, action_type, reference_id, description
- `notifications` — id, user_id, actor_id, type, reference_id, reference_type, is_read
- `reports` — id, reporter_id, target_id, target_type, reason, description, status, resolved_by

---

## 5. Migration Plan (Prioritas)

### Core (wajib)
1. Users + roles/permissions (Spatie) → migration
2. Categories + Tags → migration & seeder
3. Posts + PostTags → migration
4. Comments → migration (nested reply)
5. Votes + Likes → migration
6. Follows → migration
7. Points Log → migration

### Medium (tahap 2)
8. Post Edit History → migration
9. Comment Edit History → migration
10. Bookmarks → migration
11. Notifications → migration & event/listener
12. Reports → migration & policy
13. Search → Scout + Meilisearch/algolia config
14. Real-time → WebSocket setup (beyondcode/pusher)

---

## 6. Non-Functional Requirements

- **Response time:** < 200ms untuk read endpoints (dengan indexing & eager loading)
- **Rate limiting:** 60 req/min untuk guest, 120 req/min untuk authenticated
- **Caching:** Posts populer di-cache Redis (TTL 10 menit)
- **Queue:** Point calculation, notifikasi via queue (Horizon)
- **Security:** Sanctum token, CORS, throttling, input validation, SQL injection protection via Eloquent

---

## 7. Roles & Permissions

| Role | Permissions |
|------|------------|
| Admin | Full akses (CRUD semua resources, manage users, manage reports, manage roles) |
| Moderator | Edit/hapus post & comment, resolve reports, ban user |
| User | CRUD post sendiri, CRUD comment sendiri, vote, like, bookmark, follow, report |
