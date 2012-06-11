class CreateDoctorPersonalProfiles < ActiveRecord::Migration
  def self.up
    create_table :doctor_personal_profiles do |t|
      t.integer :doctor_id
      t.string  :interests
      t.string  :languages
      t.string  :avatar_file_name
      t.string  :avatar_content_type
      t.integer :avatar_file_size
      t.datetime :avatar_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :doctor_personal_profiles
  end
end
