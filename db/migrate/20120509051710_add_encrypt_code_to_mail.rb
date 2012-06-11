class AddEncryptCodeToMail < ActiveRecord::Migration
  def self.up
    add_column :mail, :encrypt_code, :string, :limit => 40
  end

  def self.down
    remove_column :mail, :encrypt_code
  end
end
