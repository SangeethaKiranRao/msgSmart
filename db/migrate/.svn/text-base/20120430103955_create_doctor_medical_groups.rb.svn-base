class CreateDoctorMedicalGroups < ActiveRecord::Migration
  def self.up
    create_table :doctor_medical_groups do |t|
      t.integer :doctor_id
      t.integer :medical_group_id
      t.integer :priority
      t.timestamps
    end
    add_index :doctor_medical_groups, :doctor_id
    add_index :doctor_medical_groups, :medical_group_id 
  end

  def self.down
    drop_table :doctor_medical_groups
  end
end
