class FixSpelling < ActiveRecord::Migration
  def self.up
    rename_column :assets, :responce_status, :response_status
    rename_column :assets, :responce_time, :response_time
  end

  def self.down
    rename_column :assets, :response_time, :responce_time
    rename_column :assets, :response_status, :responce_status
  end
end
