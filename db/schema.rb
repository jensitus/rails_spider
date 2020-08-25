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

ActiveRecord::Schema.define(version: 2020_08_24_120323) do

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
  end

  create_table "schedules", force: :cascade do |t|
    t.string "_ID"
    t.datetime "time"
    t.string "theater_ID"
    t.string "movie_ID"
    t.string "typename"
    t.boolean "dreid"
    t.boolean "ov"
    t.string "info"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
