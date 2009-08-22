class CreateWorkers < ActiveRecord::Migration
  def self.up
    create_table :workers, :id => false do |t|
      t.integer :state_id, :limit => 1
      t.string :name
      t.datetime :heartbeat_at
    end
  end

  def self.down
    drop_table :workers
  end
end