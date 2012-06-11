class CreateHospitalContactShares < ActiveRecord::Migration
  def self.up
    create_table :hospital_contact_shares do |t|
      t.integer :doctor_id
      t.boolean :mobile, :default => false
      t.boolean :pager,  :default => false
      t.boolean :office_number, :default => false
      t.boolean :back_line_number, :default => false
      t.boolean :assistant_number, :default => false
      t.boolean :assistant_name, :default => false
      t.boolean :work_email, :default => false
      t.boolean :office_email, :default => false
      t.boolean :personal_email, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :hospital_contact_shares
  end
end
