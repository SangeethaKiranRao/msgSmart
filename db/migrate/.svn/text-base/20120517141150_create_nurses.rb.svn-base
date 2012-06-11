class CreateNurses < ActiveRecord::Migration
  def self.up
    create_table :nurses do |t|
      t.string   :name,                      :limit => 100, :default => '', :null => true
      t.string   :email,                     :limit => 100
      t.integer  :hospital_id
      t.timestamps
    end
  end

  def self.down
    drop_table :nurses
  end
end
