class CreateDoctors < ActiveRecord::Migration
  def self.up
    create_table "doctors", :force => true do |t|
      t.string   :login,                     :limit => 40
      t.string   :name,                      :limit => 100, :default => '', :null => true
      t.string   :email,                     :limit => 100
      t.string   :crypted_password,          :limit => 40
      t.string   :salt,                      :limit => 40
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :remember_token,            :limit => 40
      t.datetime :remember_token_expires_at
      t.string   :activation_code,           :limit => 40
      t.datetime :activated_at
      t.string   :state,                     :null => :no, :default => 'passive'
      t.string   :web_login_status,              :limit => 40
      t.string   :mobile_login_status,            :limit => 40
      t.string   :web_register,                   :limit => 40
      t.string   :mobile_register,                :limit => 40
      t.string   :verify_code_mobile
      t.datetime :deleted_at
    end
    add_index :doctors, :login, :unique => true
  end

  def self.down
    drop_table "doctors"
  end
end
