# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_19_220059) do

  create_table "movies", force: :cascade do |t|
    t.string "title"
    t.string "_ID"
    t.integer "runtime"
    t.string "land"
    t.integer "year"
    t.string "originaltitle"
    t.string "typename"
    t.text "shortdescription"
    t.string "imageurl"
    t.boolean "upcoming"
    t.integer "tmdb_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "genres"
    t.boolean "complete"
    t.bigint "movie_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.string "_ID"
    t.datetime "time"
    t.string "typename"
    t.boolean "dreid"
    t.boolean "ov"
    t.string "info"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "theater_id"
    t.bigint "movie_id"
  end

  create_table "theaters", force: :cascade do |t|
    t.string "_ID"
    t.string "name"
    t.string "typename"
    t.string "address"
    t.string "telephone"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "skip_id"
  end

end
