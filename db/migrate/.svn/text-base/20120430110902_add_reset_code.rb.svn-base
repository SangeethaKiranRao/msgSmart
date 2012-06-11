class AddResetCode < ActiveRecord::Migration
  def self.up
    add_column :doctors, :reset_code, :string, :limit => 40 
  end

  def self.down
    remove_column :doctors, :reset_code
  end
end
