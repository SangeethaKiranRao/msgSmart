class CreateDoctorProfessionalProfiles < ActiveRecord::Migration
  def self.up
    create_table :doctor_professional_profiles do |t|
      t.integer  :doctor_id
      t.string   :first_name, :limit => 100, :default => ''
      t.string   :middle_name, :limit => 100, :default => ''
      t.string   :last_name, :limit => 100, :default => ''
      t.string   :office_address
      t.string   :state
      t.string   :zip_code
      t.string   :assistant_name, :limit => 100, :default => ''
      t.string   :assistant_email, :limit => 100
      t.string   :web_url
      t.string   :medical_school
      t.string   :graduation_year
      t.string   :degree
      t.string   :sub_speciality
      t.timestamps
    end
    add_index :doctor_professional_profiles, :doctor_id
  end

  def self.down
    drop_table :doctor_professional_profiles
  end
  
end
