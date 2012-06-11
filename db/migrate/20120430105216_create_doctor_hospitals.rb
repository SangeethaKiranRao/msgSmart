class CreateDoctorHospitals < ActiveRecord::Migration
  def self.up
    create_table :doctor_hospitals do |t|
      t.integer :doctor_id
      t.integer :hospital_id
      t.integer :priority
      t.timestamps
    end
    add_index :doctor_hospitals, :doctor_id
    add_index :doctor_hospitals, :hospital_id  
  end

  def self.down
    drop_table :doctor_hospitals
  end
end
