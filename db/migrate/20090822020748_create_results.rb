class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.integer :check_id, :limit => 8
      t.integer :asset_id, :limit => 4
      t.integer :message_id, :limit => 3
      t.integer :severity, :limit => 1
      t.integer :line_no, :limit => 2
      t.integer :column_no, :limit => 2
    end
  end

  def self.down
    drop_table :results
  end
end