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

ActiveRecord::Schema.define(version: 2019_02_12_090059) do

  create_table "administrators", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.string "remember_token"
    t.datetime "remember_token_expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "building_orders", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "wallet_addr", null: false
    t.string "order_hash", null: false
    t.text "order"
    t.text "param"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "content", limit: 16777215
    t.integer "room_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "message"
    t.boolean "visible"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_details", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "signedorder", limit: 16777215
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "expire"
    t.decimal "taker_amount", precision: 21, scale: 10
    t.decimal "maker_amount", precision: 21, scale: 10
  end

  create_table "orders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "type"
    t.integer "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "base_token"
    t.integer "expire"
    t.integer "detail_id"
    t.string "token_symbol"
    t.string "maker_address"
    t.decimal "amount", precision: 21, scale: 10
    t.decimal "price", precision: 21, scale: 10
    t.decimal "fee", precision: 21, scale: 10
    t.string "order_hash"
    t.decimal "total_amount", precision: 21, scale: 10
  end

  create_table "pending_trades", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "type"
    t.string "base_token"
    t.string "token_symbol"
    t.decimal "amount", precision: 21, scale: 10
    t.decimal "price", precision: 21, scale: 10
    t.string "maker_address"
    t.string "taker_address"
    t.string "txHash"
    t.boolean "reward_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "token_id"
    t.string "based_token"
    t.string "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "amount"
    t.index ["token_id"], name: "index_prices_on_token_id"
  end

  create_table "referral_managers", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "wallet_address", null: false
    t.decimal "amount", precision: 21, scale: 10
    t.boolean "approved"
    t.boolean "status", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "referral_id", null: false
    t.string "txHash"
  end

  create_table "referrals", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "referral_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reward_managers", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "wallet_address", null: false
    t.decimal "amount", precision: 21, scale: 10
    t.boolean "approved"
    t.boolean "status", default: false
    t.string "txHash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rewards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "wallet_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "amount", precision: 21, scale: 10
    t.string "state"
    t.string "txHash"
  end

  create_table "tokens", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "symbol", null: false
    t.string "contract_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "token_decimals"
    t.boolean "on_hold"
    t.boolean "tm_field"
    t.boolean "weth_token"
    t.boolean "usdc_field"
    t.decimal "last_price_weth", precision: 21, scale: 10
    t.decimal "h_price_weth", precision: 21, scale: 10
    t.decimal "h_volume_weth", precision: 21, scale: 10
    t.decimal "last_price_tm", precision: 21, scale: 10
    t.decimal "h_price_tm", precision: 21, scale: 10
    t.decimal "h_volume_tm", precision: 21, scale: 10
    t.decimal "last_price_usdc", precision: 21, scale: 10
    t.decimal "h_price_usdc", precision: 21, scale: 10
    t.decimal "h_volume_usdc", precision: 21, scale: 10
    t.boolean "wbtc_field"
    t.decimal "last_price_wbtc", precision: 21, scale: 10
    t.decimal "h_price_wbtc", precision: 21, scale: 10
    t.decimal "h_volume_wbtc", precision: 21, scale: 10
  end

  create_table "trade_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "type"
    t.string "base_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token_symbol"
    t.decimal "amount", precision: 21, scale: 10
    t.decimal "price", precision: 21, scale: 10
    t.string "maker_address"
    t.string "taker_address"
    t.string "txHash"
    t.boolean "reward_status"
    t.decimal "total_amount", precision: 21, scale: 10
    t.decimal "taker_total_amount", precision: 21, scale: 10
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "wallet_address", null: false
    t.string "nick_name", default: "Account"
    t.boolean "banned"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "referral_id"
    t.string "recommended_id"
  end

  create_table "wallets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "trading_volumn", precision: 21, scale: 10
    t.decimal "reword_volumn", precision: 21, scale: 10
  end

end
