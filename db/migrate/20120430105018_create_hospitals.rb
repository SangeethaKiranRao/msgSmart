class CreateHospitals < ActiveRecord::Migration
  def self.up
    create_table :hospitals do |t|
      t.string :name
      t.timestamps
    end
    add_index :hospitals, :name
  end

  def self.down
    drop_table :hospitals
  end
end
