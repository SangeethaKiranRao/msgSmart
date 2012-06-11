class CreateDoctorSpecialities < ActiveRecord::Migration
  def self.up
    create_table :doctor_specialities do |t|
      t.integer :doctor_id
      t.integer :speciality_id
      t.integer :priority
      t.timestamps
    end
    add_index :doctor_specialities, :doctor_id
    add_index :doctor_specialities, :speciality_id  
  end

  def self.down
    drop_table :doctor_specialities
  end
end
