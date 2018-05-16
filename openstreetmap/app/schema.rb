# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170222134109) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "btree_gist"

  create_table "acls", force: :cascade do |t|
    t.inet   "address"
    t.string "k",       null: false
    t.string "v"
    t.string "domain"
  end

  add_index "acls", ["k"], name: "acls_k_idx", using: :btree

  create_table "changeset_comments", force: :cascade do |t|
    t.integer  "changeset_id", limit: 8, null: false
    t.integer  "author_id",    limit: 8, null: false
    t.text     "body",                   null: false
    t.datetime "created_at",             null: false
    t.boolean  "visible",                null: false
  end

  add_index "changeset_comments", ["created_at"], name: "index_changeset_comments_on_created_at", using: :btree

  create_table "changeset_tags", id: false, force: :cascade do |t|
    t.integer "changeset_id", limit: 8,              null: false
    t.string  "k",                      default: "", null: false
    t.string  "v",                      default: "", null: false
  end

  add_index "changeset_tags", ["changeset_id"], name: "changeset_tags_id_idx", using: :btree

  create_table "changesets", id: :bigserial, force: :cascade do |t|
    t.integer  "user_id",     limit: 8,             null: false
    t.datetime "created_at",                        null: false
    t.integer  "min_lat"
    t.integer  "max_lat"
    t.integer  "min_lon"
    t.integer  "max_lon"
    t.datetime "closed_at",                         null: false
    t.integer  "num_changes",           default: 0, null: false
  end

  add_index "changesets", ["closed_at"], name: "changesets_closed_at_idx", using: :btree
  add_index "changesets", ["created_at"], name: "changesets_created_at_idx", using: :btree
  add_index "changesets", ["min_lat", "max_lat", "min_lon", "max_lon"], name: "changesets_bbox_idx", using: :gist
  add_index "changesets", ["user_id", "created_at"], name: "changesets_user_id_created_at_idx", using: :btree
  add_index "changesets", ["user_id", "id"], name: "changesets_user_id_id_idx", using: :btree

  create_table "changesets_subscribers", id: false, force: :cascade do |t|
    t.integer "subscriber_id", limit: 8, null: false
    t.integer "changeset_id",  limit: 8, null: false
  end

  add_index "changesets_subscribers", ["changeset_id"], name: "index_changesets_subscribers_on_changeset_id", using: :btree
  add_index "changesets_subscribers", ["subscriber_id", "changeset_id"], name: "index_changesets_subscribers_on_subscriber_id_and_changeset_id", unique: true, using: :btree

  create_table "client_applications", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "support_url"
    t.string   "callback_url"
    t.string   "key",               limit: 50
    t.string   "secret",            limit: 50
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "allow_read_prefs",             default: false, null: false
    t.boolean  "allow_write_prefs",            default: false, null: false
    t.boolean  "allow_write_diary",            default: false, null: false
    t.boolean  "allow_write_api",              default: false, null: false
    t.boolean  "allow_read_gpx",               default: false, null: false
    t.boolean  "allow_write_gpx",              default: false, null: false
    t.boolean  "allow_write_notes",            default: false, null: false
  end

  add_index "client_applications", ["key"], name: "index_client_applications_on_key", unique: true, using: :btree
  add_index "client_applications", ["user_id"], name: "index_client_applications_on_user_id", using: :btree

  create_table "current_node_tags", id: false, force: :cascade do |t|
    t.integer "node_id", limit: 8,              null: false
    t.string  "k",                 default: "", null: false
    t.string  "v",                 default: "", null: false
  end

  create_table "current_nodes", id: :bigserial, force: :cascade do |t|
    t.integer  "latitude",               null: false
    t.integer  "longitude",              null: false
    t.integer  "changeset_id", limit: 8, null: false
    t.boolean  "visible",                null: false
    t.datetime "timestamp",              null: false
    t.integer  "tile",         limit: 8, null: false
    t.integer  "version",      limit: 8, null: false
  end

  add_index "current_nodes", ["tile"], name: "current_nodes_tile_idx", using: :btree
  add_index "current_nodes", ["timestamp"], name: "current_nodes_timestamp_idx", using: :btree

# Could not dump table "current_relation_members" because of following StandardError
#   Unknown type 'nwr_enum' for column 'member_type'

  create_table "current_relation_tags", id: false, force: :cascade do |t|
    t.integer "relation_id", limit: 8,              null: false
    t.string  "k",                     default: "", null: false
    t.string  "v",                     default: "", null: false
  end

  create_table "current_relations", id: :bigserial, force: :cascade do |t|
    t.integer  "changeset_id", limit: 8, null: false
    t.datetime "timestamp",              null: false
    t.boolean  "visible",                null: false
    t.integer  "version",      limit: 8, null: false
  end

  add_index "current_relations", ["timestamp"], name: "current_relations_timestamp_idx", using: :btree

  create_table "current_way_nodes", id: false, force: :cascade do |t|
    t.integer "way_id",      limit: 8, null: false
    t.integer "node_id",     limit: 8, null: false
    t.integer "sequence_id", limit: 8, null: false
  end

  add_index "current_way_nodes", ["node_id"], name: "current_way_nodes_node_idx", using: :btree

  create_table "current_way_tags", id: false, force: :cascade do |t|
    t.integer "way_id", limit: 8,              null: false
    t.string  "k",                default: "", null: false
    t.string  "v",                default: "", null: false
  end

  create_table "current_ways", id: :bigserial, force: :cascade do |t|
    t.integer  "changeset_id", limit: 8, null: false
    t.datetime "timestamp",              null: false
    t.boolean  "visible",                null: false
    t.integer  "version",      limit: 8, null: false
  end

  add_index "current_ways", ["timestamp"], name: "current_ways_timestamp_idx", using: :btree

# Could not dump table "diary_comments" because of following StandardError
#   Unknown type 'format_enum' for column 'body_format'

# Could not dump table "diary_entries" because of following StandardError
#   Unknown type 'format_enum' for column 'body_format'

  create_table "diary_entry_subscriptions", id: false, force: :cascade do |t|
    t.integer "user_id",        limit: 8, null: false
    t.integer "diary_entry_id", limit: 8, null: false
  end

  add_index "diary_entry_subscriptions", ["diary_entry_id"], name: "index_diary_entry_subscriptions_on_diary_entry_id", using: :btree

  create_table "friends", id: :bigserial, force: :cascade do |t|
    t.integer "user_id",        limit: 8, null: false
    t.integer "friend_user_id", limit: 8, null: false
  end

  add_index "friends", ["friend_user_id"], name: "user_id_idx", using: :btree
  add_index "friends", ["user_id"], name: "friends_user_id_idx", using: :btree

  create_table "gps_points", id: false, force: :cascade do |t|
    t.float    "altitude"
    t.integer  "trackid",             null: false
    t.integer  "latitude",            null: false
    t.integer  "longitude",           null: false
    t.integer  "gpx_id",    limit: 8, null: false
    t.datetime "timestamp"
    t.integer  "tile",      limit: 8
  end

  add_index "gps_points", ["gpx_id"], name: "points_gpxid_idx", using: :btree
  add_index "gps_points", ["tile"], name: "points_tile_idx", using: :btree

  create_table "gpx_file_tags", id: :bigserial, force: :cascade do |t|
    t.integer "gpx_id", limit: 8, default: 0, null: false
    t.string  "tag",                          null: false
  end

  add_index "gpx_file_tags", ["gpx_id"], name: "gpx_file_tags_gpxid_idx", using: :btree
  add_index "gpx_file_tags", ["tag"], name: "gpx_file_tags_tag_idx", using: :btree

# Could not dump table "gpx_files" because of following StandardError
#   Unknown type 'gpx_visibility_enum' for column 'visibility'

  create_table "languages", primary_key: "code", force: :cascade do |t|
    t.string "english_name", null: false
    t.string "native_name"
  end

# Could not dump table "messages" because of following StandardError
#   Unknown type 'format_enum' for column 'body_format'

  create_table "node_tags", id: false, force: :cascade do |t|
    t.integer "node_id", limit: 8,              null: false
    t.integer "version", limit: 8,              null: false
    t.string  "k",                 default: "", null: false
    t.string  "v",                 default: "", null: false
  end

  create_table "nodes", id: false, force: :cascade do |t|
    t.integer  "node_id",      limit: 8, null: false
    t.integer  "latitude",               null: false
    t.integer  "longitude",              null: false
    t.integer  "changeset_id", limit: 8, null: false
    t.boolean  "visible",                null: false
    t.datetime "timestamp",              null: false
    t.integer  "tile",         limit: 8, null: false
    t.integer  "version",      limit: 8, null: false
    t.integer  "redaction_id"
  end

  add_index "nodes", ["changeset_id"], name: "nodes_changeset_id_idx", using: :btree
  add_index "nodes", ["tile"], name: "nodes_tile_idx", using: :btree
  add_index "nodes", ["timestamp"], name: "nodes_timestamp_idx", using: :btree

# Could not dump table "note_comments" because of following StandardError
#   Unknown type 'note_event_enum' for column 'event'

# Could not dump table "notes" because of following StandardError
#   Unknown type 'note_status_enum' for column 'status'

  create_table "oauth_nonces", force: :cascade do |t|
    t.string   "nonce"
    t.integer  "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_nonces", ["nonce", "timestamp"], name: "index_oauth_nonces_on_nonce_and_timestamp", unique: true, using: :btree

  create_table "oauth_tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "type",                  limit: 20
    t.integer  "client_application_id"
    t.string   "token",                 limit: 50
    t.string   "secret",                limit: 50
    t.datetime "authorized_at"
    t.datetime "invalidated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "allow_read_prefs",                 default: false, null: false
    t.boolean  "allow_write_prefs",                default: false, null: false
    t.boolean  "allow_write_diary",                default: false, null: false
    t.boolean  "allow_write_api",                  default: false, null: false
    t.boolean  "allow_read_gpx",                   default: false, null: false
    t.boolean  "allow_write_gpx",                  default: false, null: false
    t.string   "callback_url"
    t.string   "verifier",              limit: 20
    t.string   "scope"
    t.datetime "valid_to"
    t.boolean  "allow_write_notes",                default: false, null: false
  end

  add_index "oauth_tokens", ["token"], name: "index_oauth_tokens_on_token", unique: true, using: :btree
  add_index "oauth_tokens", ["user_id"], name: "index_oauth_tokens_on_user_id", using: :btree

# Could not dump table "redactions" because of following StandardError
#   Unknown type 'format_enum' for column 'description_format'

# Could not dump table "relation_members" because of following StandardError
#   Unknown type 'nwr_enum' for column 'member_type'

  create_table "relation_tags", id: false, force: :cascade do |t|
    t.integer "relation_id", limit: 8, default: 0,  null: false
    t.string  "k",                     default: "", null: false
    t.string  "v",                     default: "", null: false
    t.integer "version",     limit: 8,              null: false
  end

  create_table "relations", id: false, force: :cascade do |t|
    t.integer  "relation_id",  limit: 8, default: 0,    null: false
    t.integer  "changeset_id", limit: 8,                null: false
    t.datetime "timestamp",                             null: false
    t.integer  "version",      limit: 8,                null: false
    t.boolean  "visible",                default: true, null: false
    t.integer  "redaction_id"
  end

  add_index "relations", ["changeset_id"], name: "relations_changeset_id_idx", using: :btree
  add_index "relations", ["timestamp"], name: "relations_timestamp_idx", using: :btree

# Could not dump table "user_blocks" because of following StandardError
#   Unknown type 'format_enum' for column 'reason_format'

  create_table "user_preferences", id: false, force: :cascade do |t|
    t.integer "user_id", limit: 8, null: false
    t.string  "k",                 null: false
    t.string  "v",                 null: false
  end

# Could not dump table "user_roles" because of following StandardError
#   Unknown type 'user_role_enum' for column 'role'

  create_table "user_tokens", id: :bigserial, force: :cascade do |t|
    t.integer  "user_id", limit: 8, null: false
    t.string   "token",             null: false
    t.datetime "expiry",            null: false
    t.text     "referer"
  end

  add_index "user_tokens", ["token"], name: "user_tokens_token_idx", unique: true, using: :btree
  add_index "user_tokens", ["user_id"], name: "user_tokens_user_id_idx", using: :btree

# Could not dump table "users" because of following StandardError
#   Unknown type 'user_status_enum' for column 'status'

  create_table "way_nodes", id: false, force: :cascade do |t|
    t.integer "way_id",      limit: 8, null: false
    t.integer "node_id",     limit: 8, null: false
    t.integer "version",     limit: 8, null: false
    t.integer "sequence_id", limit: 8, null: false
  end

  add_index "way_nodes", ["node_id"], name: "way_nodes_node_idx", using: :btree

  create_table "way_tags", id: false, force: :cascade do |t|
    t.integer "way_id",  limit: 8, default: 0, null: false
    t.string  "k",                             null: false
    t.string  "v",                             null: false
    t.integer "version", limit: 8,             null: false
  end

  create_table "ways", id: false, force: :cascade do |t|
    t.integer  "way_id",       limit: 8, default: 0,    null: false
    t.integer  "changeset_id", limit: 8,                null: false
    t.datetime "timestamp",                             null: false
    t.integer  "version",      limit: 8,                null: false
    t.boolean  "visible",                default: true, null: false
    t.integer  "redaction_id"
  end

  add_index "ways", ["changeset_id"], name: "ways_changeset_id_idx", using: :btree
  add_index "ways", ["timestamp"], name: "ways_timestamp_idx", using: :btree

  add_foreign_key "changeset_comments", "changesets", name: "changeset_comments_changeset_id_fkey"
  add_foreign_key "changeset_comments", "users", column: "author_id", name: "changeset_comments_author_id_fkey"
  add_foreign_key "changeset_tags", "changesets", name: "changeset_tags_id_fkey"
  add_foreign_key "changesets", "users", name: "changesets_user_id_fkey"
  add_foreign_key "changesets_subscribers", "changesets", name: "changesets_subscribers_changeset_id_fkey"
  add_foreign_key "changesets_subscribers", "users", column: "subscriber_id", name: "changesets_subscribers_subscriber_id_fkey"
  add_foreign_key "client_applications", "users", name: "client_applications_user_id_fkey"
  add_foreign_key "current_node_tags", "current_nodes", column: "node_id", name: "current_node_tags_id_fkey"
  add_foreign_key "current_nodes", "changesets", name: "current_nodes_changeset_id_fkey"
  add_foreign_key "current_relation_members", "current_relations", column: "relation_id", name: "current_relation_members_id_fkey"
  add_foreign_key "current_relation_tags", "current_relations", column: "relation_id", name: "current_relation_tags_id_fkey"
  add_foreign_key "current_relations", "changesets", name: "current_relations_changeset_id_fkey"
  add_foreign_key "current_way_nodes", "current_nodes", column: "node_id", name: "current_way_nodes_node_id_fkey"
  add_foreign_key "current_way_nodes", "current_ways", column: "way_id", name: "current_way_nodes_id_fkey"
  add_foreign_key "current_way_tags", "current_ways", column: "way_id", name: "current_way_tags_id_fkey"
  add_foreign_key "current_ways", "changesets", name: "current_ways_changeset_id_fkey"
  add_foreign_key "diary_comments", "diary_entries", name: "diary_comments_diary_entry_id_fkey"
  add_foreign_key "diary_comments", "users", name: "diary_comments_user_id_fkey"
  add_foreign_key "diary_entries", "languages", column: "language_code", primary_key: "code", name: "diary_entries_language_code_fkey"
  add_foreign_key "diary_entries", "users", name: "diary_entries_user_id_fkey"
  add_foreign_key "diary_entry_subscriptions", "diary_entries", name: "diary_entry_subscriptions_diary_entry_id_fkey"
  add_foreign_key "diary_entry_subscriptions", "users", name: "diary_entry_subscriptions_user_id_fkey"
  add_foreign_key "friends", "users", column: "friend_user_id", name: "friends_friend_user_id_fkey"
  add_foreign_key "friends", "users", name: "friends_user_id_fkey"
  add_foreign_key "gps_points", "gpx_files", column: "gpx_id", name: "gps_points_gpx_id_fkey"
  add_foreign_key "gpx_file_tags", "gpx_files", column: "gpx_id", name: "gpx_file_tags_gpx_id_fkey"
  add_foreign_key "gpx_files", "users", name: "gpx_files_user_id_fkey"
  add_foreign_key "messages", "users", column: "from_user_id", name: "messages_from_user_id_fkey"
  add_foreign_key "messages", "users", column: "to_user_id", name: "messages_to_user_id_fkey"
  add_foreign_key "node_tags", "nodes", primary_key: "node_id", name: "node_tags_id_fkey"
  add_foreign_key "nodes", "changesets", name: "nodes_changeset_id_fkey"
  add_foreign_key "nodes", "redactions", name: "nodes_redaction_id_fkey"
  add_foreign_key "note_comments", "notes", name: "note_comments_note_id_fkey"
  add_foreign_key "note_comments", "users", column: "author_id", name: "note_comments_author_id_fkey"
  add_foreign_key "oauth_tokens", "client_applications", name: "oauth_tokens_client_application_id_fkey"
  add_foreign_key "oauth_tokens", "users", name: "oauth_tokens_user_id_fkey"
  add_foreign_key "redactions", "users", name: "redactions_user_id_fkey"
  add_foreign_key "relation_members", "relations", primary_key: "relation_id", name: "relation_members_id_fkey"
  add_foreign_key "relation_tags", "relations", primary_key: "relation_id", name: "relation_tags_id_fkey"
  add_foreign_key "relations", "changesets", name: "relations_changeset_id_fkey"
  add_foreign_key "relations", "redactions", name: "relations_redaction_id_fkey"
  add_foreign_key "user_blocks", "users", column: "creator_id", name: "user_blocks_moderator_id_fkey"
  add_foreign_key "user_blocks", "users", column: "revoker_id", name: "user_blocks_revoker_id_fkey"
  add_foreign_key "user_blocks", "users", name: "user_blocks_user_id_fkey"
  add_foreign_key "user_preferences", "users", name: "user_preferences_user_id_fkey"
  add_foreign_key "user_roles", "users", column: "granter_id", name: "user_roles_granter_id_fkey"
  add_foreign_key "user_roles", "users", name: "user_roles_user_id_fkey"
  add_foreign_key "user_tokens", "users", name: "user_tokens_user_id_fkey"
  add_foreign_key "way_nodes", "ways", primary_key: "way_id", name: "way_nodes_id_fkey"
  add_foreign_key "way_tags", "ways", primary_key: "way_id", name: "way_tags_id_fkey"
  add_foreign_key "ways", "changesets", name: "ways_changeset_id_fkey"
  add_foreign_key "ways", "redactions", name: "ways_redaction_id_fkey"
end
