class CreateSpecialities < ActiveRecord::Migration
  def self.up
    create_table :specialities do |t|
      t.string :name
      t.timestamps
    end
    add_index :specialities , :name
  end

  def self.down
    drop_table :specialities
  end
end
