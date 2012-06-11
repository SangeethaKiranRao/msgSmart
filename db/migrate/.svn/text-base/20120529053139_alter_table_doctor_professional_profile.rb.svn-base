class AlterTableDoctorProfessionalProfile < ActiveRecord::Migration
  def self.up
    rename_column :doctor_professional_profiles, :pin_code, :secure_pin
    add_column :doctor_professional_profiles, :use_secure_pin, :boolean, :default => true
  end

  def self.down
    rename_column :doctor_professional_profiles, :secure_pin, :pin_code
    remove_column :doctor_professional_profiles, :use_secure_pin
  end
end
