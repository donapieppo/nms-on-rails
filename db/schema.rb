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

ActiveRecord::Schema.define(version: 0) do

  create_table "arps", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "ip_id", default: 0, null: false, unsigned: true
    t.string "mac", limit: 17
    t.timestamp "date", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["ip_id", "mac", "date"], name: "ip_id", unique: true
  end

  create_table "facts", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "ip_id", null: false, unsigned: true
    t.integer "memorysize"
    t.string "processor", limit: 50
    t.integer "processorcount"
    t.string "lsbdistrelease", limit: 20
    t.string "lsbdistid", limit: 20
    t.string "kernelrelease", limit: 100
    t.timestamp "date", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "infos", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "ip_id", default: 0, null: false, unsigned: true
    t.timestamp "date", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.text "name"
    t.text "dnsname"
    t.text "comment"
    t.integer "user_id", default: 0, null: false, unsigned: true
    t.boolean "dhcp"
    t.index ["ip_id", "date"], name: "ip_id", unique: true
  end

  create_table "ips", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "ip", limit: 15, default: "", null: false
    t.integer "last_arp_id", unsigned: true
    t.integer "last_info_id", unsigned: true
    t.string "conn_proto", limit: 5
    t.boolean "notify"
    t.integer "network_id"
    t.integer "last_system_id", unsigned: true
    t.index ["ip"], name: "ip", unique: true
  end

  create_table "networks", id: :integer, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name", limit: 250
    t.text "description"
  end

  create_table "ports", id: :integer, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "switch_id"
    t.integer "port"
    t.string "mac", limit: 17
    t.datetime "last"
    t.datetime "start"
    t.index ["mac"], name: "index_ports_on_mac"
    t.index ["switch_id"], name: "index_ports_on_switch_id"
  end

  create_table "switches", id: :integer, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "ip", limit: 20
    t.string "name", limit: 250
    t.string "description"
    t.string "model"
    t.string "community", limit: 100
  end

  create_table "systems", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "ip_id", null: false, unsigned: true
    t.string "name"
    t.timestamp "date", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["ip_id"], name: "index_oss_on_ip_id"
  end

  create_table "users", id: :integer, default: 0, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "login", limit: 15
    t.text "gecos"
  end

end
