class CreateMedicalGroups < ActiveRecord::Migration
  def self.up
    create_table :medical_groups do |t|
      t.string :name
      t.timestamps
    end
    add_index :medical_groups, :name
  end

  def self.down
    drop_table :medical_groups
  end
end
