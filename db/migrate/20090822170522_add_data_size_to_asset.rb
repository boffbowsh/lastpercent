class AddDataSizeToAsset < ActiveRecord::Migration
  def self.up
    add_column :assets, :content_length, :integer, :limit => 3
  end

  def self.down
    remove_column :assets, :content_length
  end
end
