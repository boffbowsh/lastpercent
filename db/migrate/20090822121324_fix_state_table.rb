class FixStateTable < ActiveRecord::Migration
  def self.up
    rename_column :states, :type, :state_type
  end

  def self.down
    rename_column :states, :state_type, :type
  end
end
