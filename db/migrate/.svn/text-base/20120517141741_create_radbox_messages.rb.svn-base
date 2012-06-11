class CreateRadboxMessages < ActiveRecord::Migration
  def self.up
    create_table :radbox_messages do |t|
      t.integer :sender_id, :recipient_id
      t.boolean :sender_deleted, :recipient_deleted, :default => 0
      t.string :subject
      t.text :body
      t.datetime :read_at
      t.timestamps
    end
  end

  def self.down
    drop_table radbox_messages
  end
end