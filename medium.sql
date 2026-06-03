// ============================================================
// Forum Diskusi - Stack Overflow Style
// LEVEL: CORE + MEDIUM
// Generated for dbdiagram.io
// ============================================================

// ─── AUTH & USER MANAGEMENT ─────────────────────────────────

Table users {
  id uuid [pk, default: `gen_random_uuid()`]
  username varchar(100) [not null]
  email varchar(255) [not null]
  password_hash varchar(255) [not null]
  avatar_url varchar(500)
  bio text
  reputation_points int [not null, default: 0]
  level int [not null, default: 1]
  is_banned boolean [not null, default: false]
  created_at timestamp [not null, default: `now()`]
  updated_at timestamp [not null, default: `now()`]

  Indexes {
    email [unique, name: "users_email_unique"]
    username [unique, name: "users_username_unique"]
  }
}

Table roles {
  id uuid [pk, default: `gen_random_uuid()`]
  name varchar(50) [not null, note: 'admin, moderator, user']
  permissions json
  created_at timestamp [not null, default: `now()`]

  Indexes {
    name [unique, name: "roles_name_unique"]
  }
}

Table user_roles {
  id uuid [pk, default: `gen_random_uuid()`]
  user_id uuid [not null]
  role_id uuid [not null]
  assigned_at timestamp [not null, default: `now()`]

  Indexes {
    (user_id, role_id) [unique, name: "user_roles_unique"]
  }
}

// ─── KATEGORI & TAG ─────────────────────────────────────────

Table categories {
  id uuid [pk, default: `gen_random_uuid()`]
  name varchar(100) [not null]
  slug varchar(120) [not null]
  description text
  parent_id uuid [note: 'null = root category']
  created_at timestamp [not null, default: `now()`]

  Indexes {
    slug [unique, name: "categories_slug_unique"]
  }
}

Table tags {
  id uuid [pk, default: `gen_random_uuid()`]
  name varchar(50) [not null]
  slug varchar(60) [not null]
  color varchar(7) [note: 'hex color e.g. #3B82F6']
  usage_count int [not null, default: 0]
  created_at timestamp [not null, default: `now()`]

  Indexes {
    slug [unique, name: "tags_slug_unique"]
  }
}

// ─── POSTINGAN ──────────────────────────────────────────────

Table posts {
  id uuid [pk, default: `gen_random_uuid()`]
  user_id uuid [not null]
  category_id uuid [not null]
  title varchar(300) [not null]
  body text [not null]
  status varchar(20) [not null, default: 'open', note: 'open, closed, deleted']
  view_count int [not null, default: 0]
  vote_score int [not null, default: 0]
  is_answered boolean [not null, default: false]
  accepted_answer_id uuid [note: 'FK to comments.id']
  created_at timestamp [not null, default: `now()`]
  updated_at timestamp [not null, default: `now()`]

  Indexes {
    user_id [name: "posts_user_id_idx"]
    category_id [name: "posts_category_id_idx"]
    status [name: "posts_status_idx"]
    created_at [name: "posts_created_at_idx"]
  }
}

Table post_tags {
  id uuid [pk, default: `gen_random_uuid()`]
  post_id uuid [not null]
  tag_id uuid [not null]

  Indexes {
    (post_id, tag_id) [unique, name: "post_tags_unique"]
  }
}

// [MEDIUM] Edit history postingan
Table post_edit_history {
  id uuid [pk, default: `gen_random_uuid()`]
  post_id uuid [not null]
  edited_by uuid [not null]
  body_before text [not null]
  body_after text [not null]
  reason varchar(255)
  edited_at timestamp [not null, default: `now()`]

  Indexes {
    post_id [name: "post_edit_history_post_id_idx"]
  }
}

// ─── KOMENTAR & REPLY ───────────────────────────────────────

Table comments {
  id uuid [pk, default: `gen_random_uuid()`]
  post_id uuid [not null]
  user_id uuid [not null]
  parent_id uuid [note: 'null = top-level comment, filled = reply']
  body text [not null]
  vote_score int [not null, default: 0]
  is_accepted boolean [not null, default: false]
  created_at timestamp [not null, default: `now()`]
  updated_at timestamp [not null, default: `now()`]

  Indexes {
    post_id [name: "comments_post_id_idx"]
    user_id [name: "comments_user_id_idx"]
    parent_id [name: "comments_parent_id_idx"]
  }
}

// [MEDIUM] Edit history komentar
Table comment_edit_history {
  id uuid [pk, default: `gen_random_uuid()`]
  comment_id uuid [not null]
  edited_by uuid [not null]
  body_before text [not null]
  body_after text [not null]
  edited_at timestamp [not null, default: `now()`]

  Indexes {
    comment_id [name: "comment_edit_history_comment_id_idx"]
  }
}

// ─── INTERAKSI ──────────────────────────────────────────────

Table votes {
  id uuid [pk, default: `gen_random_uuid()`]
  user_id uuid [not null]
  target_id uuid [not null, note: 'post_id or comment_id']
  target_type varchar(20) [not null, note: 'post, comment']
  vote_type varchar(10) [not null, note: 'upvote, downvote']
  created_at timestamp [not null, default: `now()`]

  Indexes {
    (user_id, target_id, target_type) [unique, name: "votes_unique"]
    (target_id, target_type) [name: "votes_target_idx"]
  }
}

Table likes {
  id uuid [pk, default: `gen_random_uuid()`]
  user_id uuid [not null]
  target_id uuid [not null, note: 'post_id or comment_id']
  target_type varchar(20) [not null, note: 'post, comment']
  created_at timestamp [not null, default: `now()`]

  Indexes {
    (user_id, target_id, target_type) [unique, name: "likes_unique"]
    (target_id, target_type) [name: "likes_target_idx"]
  }
}

// [MEDIUM] Bookmark / save post
Table bookmarks {
  id uuid [pk, default: `gen_random_uuid()`]
  user_id uuid [not null]
  post_id uuid [not null]
  created_at timestamp [not null, default: `now()`]

  Indexes {
    (user_id, post_id) [unique, name: "bookmarks_unique"]
  }
}

Table follows {
  id uuid [pk, default: `gen_random_uuid()`]
  follower_id uuid [not null]
  following_id uuid [not null]
  created_at timestamp [not null, default: `now()`]

  Indexes {
    (follower_id, following_id) [unique, name: "follows_unique"]
    follower_id [name: "follows_follower_idx"]
    following_id [name: "follows_following_idx"]
  }
}

// ─── POINTS & REPUTATION ────────────────────────────────────

Table points_log {
  id uuid [pk, default: `gen_random_uuid()`]
  user_id uuid [not null]
  points int [not null, note: 'positive = earn, negative = deduct']
  action_type varchar(50) [not null, note: 'post_upvoted, answer_accepted, comment_upvoted, post_created, etc']
  reference_id uuid [note: 'related post_id or comment_id']
  description varchar(255)
  created_at timestamp [not null, default: `now()`]

  Indexes {
    user_id [name: "points_log_user_id_idx"]
    action_type [name: "points_log_action_type_idx"]
  }
}

// ─── NOTIFIKASI [MEDIUM] ────────────────────────────────────

Table notifications {
  id uuid [pk, default: `gen_random_uuid()`]
  user_id uuid [not null, note: 'recipient']
  actor_id uuid [note: 'who triggered the notification']
  type varchar(50) [not null, note: 'reply, like, upvote, follow, answer_accepted, mention']
  reference_id uuid [note: 'related post_id or comment_id']
  reference_type varchar(20) [note: 'post, comment']
  is_read boolean [not null, default: false]
  created_at timestamp [not null, default: `now()`]

  Indexes {
    user_id [name: "notifications_user_id_idx"]
    (user_id, is_read) [name: "notifications_user_unread_idx"]
    created_at [name: "notifications_created_at_idx"]
  }
}

// ─── MODERASI [MEDIUM] ──────────────────────────────────────

Table reports {
  id uuid [pk, default: `gen_random_uuid()`]
  reporter_id uuid [not null]
  target_id uuid [not null, note: 'post_id or comment_id or user_id']
  target_type varchar(20) [not null, note: 'post, comment, user']
  reason varchar(100) [not null, note: 'spam, harassment, misinformation, inappropriate, etc']
  description text
  status varchar(20) [not null, default: 'pending', note: 'pending, reviewed, resolved, dismissed']
  resolved_by uuid [note: 'moderator user_id']
  created_at timestamp [not null, default: `now()`]
  resolved_at timestamp

  Indexes {
    reporter_id [name: "reports_reporter_id_idx"]
    (target_id, target_type) [name: "reports_target_idx"]
    status [name: "reports_status_idx"]
  }
}

// ============================================================
// RELATIONSHIPS
// ============================================================

// Auth & Roles
Ref: user_roles.user_id > users.id [delete: cascade]
Ref: user_roles.role_id > roles.id [delete: cascade]

// Kategori (self-referencing)
Ref: categories.parent_id > categories.id [delete: set null]

// Posts
Ref: posts.user_id > users.id [delete: cascade]
Ref: posts.category_id > categories.id [delete: restrict]
Ref: posts.accepted_answer_id > comments.id [delete: set null]

// Post Tags
Ref: post_tags.post_id > posts.id [delete: cascade]
Ref: post_tags.tag_id > tags.id [delete: cascade]

// Post Edit History [MEDIUM]
Ref: post_edit_history.post_id > posts.id [delete: cascade]
Ref: post_edit_history.edited_by > users.id [delete: cascade]

// Comments (self-referencing untuk reply)
Ref: comments.post_id > posts.id [delete: cascade]
Ref: comments.user_id > users.id [delete: cascade]
Ref: comments.parent_id > comments.id [delete: cascade]

// Comment Edit History [MEDIUM]
Ref: comment_edit_history.comment_id > comments.id [delete: cascade]
Ref: comment_edit_history.edited_by > users.id [delete: cascade]

// Votes
Ref: votes.user_id > users.id [delete: cascade]

// Likes
Ref: likes.user_id > users.id [delete: cascade]

// Bookmarks [MEDIUM]
Ref: bookmarks.user_id > users.id [delete: cascade]
Ref: bookmarks.post_id > posts.id [delete: cascade]

// Follows
Ref: follows.follower_id > users.id [delete: cascade]
Ref: follows.following_id > users.id [delete: cascade]

// Points Log
Ref: points_log.user_id > users.id [delete: cascade]

// Notifications [MEDIUM]
Ref: notifications.user_id > users.id [delete: cascade]
Ref: notifications.actor_id > users.id [delete: set null]

// Reports [MEDIUM]
Ref: reports.reporter_id > users.id [delete: cascade]
Ref: reports.resolved_by > users.id [delete: set null]