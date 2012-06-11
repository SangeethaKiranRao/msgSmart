class CreateDoctorContactInfos < ActiveRecord::Migration
  def self.up
    create_table :doctor_contact_infos do |t|
      t.integer :doctor_id
      t.string :mobile_number
      t.string :pager
      t.string :office_number
      t.string :back_line_number
      t.string :assistant_number
      t.string :assistant_name
      t.string :work_email
      t.string :office_email
      t.string :personal_email
      t.timestamps
    end
  end

  def self.down
    drop_table :doctor_contact_infos
  end
end
