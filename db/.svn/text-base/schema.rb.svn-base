# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120529053139) do

  create_table "conversations", :force => true do |t|
    t.string   "subject",    :default => ""
    t.datetime "created_at",                 :null => false
  end

  create_table "doctor_contact_infos", :force => true do |t|
    t.integer  "doctor_id"
    t.integer  "mobile_number",    :limit => 8
    t.string   "pager"
    t.string   "office_number"
    t.string   "back_line_number"
    t.string   "assistant_number"
    t.string   "assistant_name"
    t.string   "work_email"
    t.string   "office_email"
    t.string   "personal_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "doctor_contact_shares", :force => true do |t|
    t.integer  "doctor_id"
    t.boolean  "mobile",           :default => false
    t.boolean  "pager",            :default => false
    t.boolean  "office_number",    :default => false
    t.boolean  "back_line_number", :default => false
    t.boolean  "assistant_number", :default => false
    t.boolean  "assistant_name",   :default => false
    t.boolean  "work_email",       :default => false
    t.boolean  "office_email",     :default => false
    t.boolean  "personal_email",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "doctor_hospitals", :force => true do |t|
    t.integer  "doctor_id"
    t.integer  "hospital_id"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "doctor_hospitals", ["doctor_id"], :name => "index_doctor_hospitals_on_doctor_id"
  add_index "doctor_hospitals", ["hospital_id"], :name => "index_doctor_hospitals_on_hospital_id"

  create_table "doctor_medical_groups", :force => true do |t|
    t.integer  "doctor_id"
    t.integer  "medical_group_id"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "doctor_medical_groups", ["doctor_id"], :name => "index_doctor_medical_groups_on_doctor_id"
  add_index "doctor_medical_groups", ["medical_group_id"], :name => "index_doctor_medical_groups_on_medical_group_id"

  create_table "doctor_personal_profiles", :force => true do |t|
    t.integer  "doctor_id"
    t.string   "interests"
    t.string   "languages"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "doctor_professional_profiles", :force => true do |t|
    t.integer  "doctor_id"
    t.string   "first_name",      :limit => 100, :default => ""
    t.string   "middle_name",     :limit => 100, :default => ""
    t.string   "last_name",       :limit => 100, :default => ""
    t.string   "office_address"
    t.string   "state"
    t.string   "zip_code"
    t.string   "assistant_name",  :limit => 100, :default => ""
    t.string   "assistant_email", :limit => 100
    t.string   "web_url"
    t.string   "medical_school"
    t.string   "graduation_year"
    t.string   "degree"
    t.string   "sub_speciality"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "secure_pin"
    t.boolean  "use_secure_pin",                 :default => true
  end

  add_index "doctor_professional_profiles", ["doctor_id"], :name => "index_doctor_professional_profiles_on_doctor_id"

  create_table "doctor_specialities", :force => true do |t|
    t.integer  "doctor_id"
    t.integer  "speciality_id"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "doctor_specialities", ["doctor_id"], :name => "index_doctor_specialities_on_doctor_id"
  add_index "doctor_specialities", ["speciality_id"], :name => "index_doctor_specialities_on_speciality_id"

  create_table "doctors", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                    :default => "passive"
    t.string   "web_login_status",          :limit => 40
    t.string   "mobile_login_status",       :limit => 40
    t.string   "web_register",              :limit => 40
    t.string   "mobile_register",           :limit => 40
    t.string   "verify_code_mobile"
    t.datetime "deleted_at"
    t.string   "reset_code",                :limit => 40
    t.integer  "mobile_number",             :limit => 8
  end

  add_index "doctors", ["login"], :name => "index_doctors_on_login", :unique => true

  create_table "hospital_contact_shares", :force => true do |t|
    t.integer  "doctor_id"
    t.boolean  "mobile",           :default => false
    t.boolean  "pager",            :default => false
    t.boolean  "office_number",    :default => false
    t.boolean  "back_line_number", :default => false
    t.boolean  "assistant_number", :default => false
    t.boolean  "assistant_name",   :default => false
    t.boolean  "work_email",       :default => false
    t.boolean  "office_email",     :default => false
    t.boolean  "personal_email",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hospitals", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hospitals", ["name"], :name => "index_hospitals_on_name"

  create_table "mail", :force => true do |t|
    t.integer  "doctor_id",                                        :null => false
    t.integer  "message_id",                                       :null => false
    t.integer  "conversation_id"
    t.boolean  "read",                          :default => false
    t.boolean  "trashed",                       :default => false
    t.string   "mailbox",         :limit => 25
    t.datetime "created_at",                                       :null => false
    t.string   "encrypt_code",    :limit => 40
  end

  create_table "medical_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "medical_groups", ["name"], :name => "index_medical_groups_on_name"

  create_table "messages", :force => true do |t|
    t.text     "body"
    t.string   "subject",         :default => ""
    t.text     "headers"
    t.integer  "sender_id",                          :null => false
    t.integer  "conversation_id"
    t.boolean  "sent",            :default => false
    t.datetime "created_at",                         :null => false
  end

  create_table "messages_recipients", :id => false, :force => true do |t|
    t.integer "message_id",   :null => false
    t.integer "recipient_id", :null => false
  end

  create_table "nurses", :force => true do |t|
    t.string   "name",        :limit => 100, :default => ""
    t.string   "email",       :limit => 100
    t.integer  "hospital_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pictures", :force => true do |t|
    t.string   "photo_file_name"
    t.string   "photo_file_content_type"
    t.integer  "photo_file_size"
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "public_contact_shares", :force => true do |t|
    t.integer  "doctor_id"
    t.boolean  "mobile",           :default => false
    t.boolean  "pager",            :default => false
    t.boolean  "office_number",    :default => false
    t.boolean  "back_line_number", :default => false
    t.boolean  "assistant_number", :default => false
    t.boolean  "assistant_name",   :default => false
    t.boolean  "work_email",       :default => false
    t.boolean  "office_email",     :default => false
    t.boolean  "personal_email",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quick_contacts", :force => true do |t|
    t.integer  "doctor_id"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quick_contacts", ["contact_id"], :name => "index_quick_contacts_on_contact_id"
  add_index "quick_contacts", ["doctor_id"], :name => "index_quick_contacts_on_doctor_id"

  create_table "radbox_messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.boolean  "sender_deleted",    :default => false
    t.boolean  "recipient_deleted", :default => false
    t.string   "subject"
    t.text     "body"
    t.datetime "read_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "specialities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "specialities", ["name"], :name => "index_specialities_on_name"

end
