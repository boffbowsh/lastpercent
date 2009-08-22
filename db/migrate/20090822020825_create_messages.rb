class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer :validator_id, :limit => 1
      t.text :body
    end
  end

  def self.down
    drop_table :messages
  end
end