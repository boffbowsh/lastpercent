class CreateChecks < ActiveRecord::Migration
  def self.up
    create_table :checks do |t|
      t.integer :asset_id,      :limit => 4
      t.integer :worked_id,     :limit => 1
      t.integer :validator_id,  :limit => 1
      t.integer :duration,      :limit => 2
      t.integer :state_id,      :limit => 1
      t.datetime :started_at
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :checks
  end
end