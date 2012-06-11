class CreateQuickContacts < ActiveRecord::Migration
  def self.up
    create_table :quick_contacts do |t|
      t.integer :doctor_id
      t.integer :contact_id  
      t.timestamps
    end
    add_index :quick_contacts, :doctor_id
    add_index :quick_contacts, :contact_id  
  end

  def self.down
    drop_table :quick_contacts
  end
end
