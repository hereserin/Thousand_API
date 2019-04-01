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

ActiveRecord::Schema.define(version: 2019_04_01_190905) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pages", force: :cascade do |t|
    t.string "url", null: false
    t.string "title"
    t.decimal "page_rank"
    t.index ["url"], name: "index_pages_on_url", unique: true
  end

  create_table "pages_outbound_links", force: :cascade do |t|
    t.integer "page_id", null: false
    t.integer "outbound_link_id", null: false
    t.index ["outbound_link_id"], name: "index_pages_outbound_links_on_outbound_link_id"
    t.index ["page_id", "outbound_link_id"], name: "index_pages_outbound_links_on_page_id_and_outbound_link_id", unique: true
    t.index ["page_id"], name: "index_pages_outbound_links_on_page_id"
  end

  create_table "paragraphs", force: :cascade do |t|
    t.integer "page_id", null: false
    t.text "content", null: false
    t.index ["page_id"], name: "index_paragraphs_on_page_id"
  end

end
