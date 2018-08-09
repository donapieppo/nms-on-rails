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

ActiveRecord::Schema.define(version: 0) do

  create_table "arps", force: true do |t|
    t.integer   "ip_id",            default: 0, null: false
    t.string    "mac",   limit: 17
    t.timestamp "date",                         null: false
  end

  add_index "arps", ["ip_id", "mac", "date"], name: "ip_id", unique: true, using: :btree

  create_table "facts", force: true do |t|
    t.integer   "ip_id",                      null: false
    t.integer   "memorysize"
    t.string    "processor",      limit: 50
    t.integer   "processorcount"
    t.string    "lsbdistrelease", limit: 20
    t.string    "lsbdistid",      limit: 20
    t.string    "kernelrelease",  limit: 100
    t.timestamp "date",                       null: false
  end

  create_table "infos", force: true do |t|
    t.integer   "ip_id",   default: 0, null: false
    t.timestamp "date",                null: false
    t.text      "name"
    t.text      "dnsname"
    t.text      "comment"
    t.integer   "user_id", default: 0, null: false
    t.boolean   "dhcp"
  end

  add_index "infos", ["ip_id", "date"], name: "ip_id", unique: true, using: :btree

  create_table "ips", force: true do |t|
    t.string  "ip",             limit: 15, default: "", null: false
    t.integer "last_arp_id"
    t.integer "last_info_id"
    t.string  "conn_proto",     limit: 5
    t.boolean "notify"
    t.integer "network_id"
    t.integer "last_system_id"
  end

  add_index "ips", ["ip"], name: "ip", unique: true, using: :btree

  create_table "networks", force: true do |t|
    t.string "name",        limit: 250
    t.text   "description"
  end

  create_table "ports", force: true do |t|
    t.integer  "switch_id"
    t.integer  "port"
    t.string   "mac",       limit: 17
    t.datetime "last"
    t.datetime "start"
  end

  add_index "ports", ["mac"], name: "index_ports_on_mac", using: :btree
  add_index "ports", ["switch_id"], name: "index_ports_on_switch_id", using: :btree

  create_table "switches", force: true do |t|
    t.string "ip",        limit: 20
    t.string "name",      limit: 250
    t.string "community", limit: 100
  end

  create_table "systems", force: true do |t|
    t.integer   "ip_id", null: false
    t.string    "name"
    t.timestamp "date",  null: false
  end

  add_index "systems", ["ip_id"], name: "index_oss_on_ip_id", using: :btree

  create_table "users", force: true do |t|
    t.string "login", limit: 150
    t.text   "gecos"
  end

end
