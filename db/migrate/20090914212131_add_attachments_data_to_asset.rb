class AddAttachmentsDataToAsset < ActiveRecord::Migration
  def self.up
    add_column :assets, :data_file_name, :string
    add_column :assets, :data_updated_at, :datetime
  end

  def self.down
    remove_column :assets, :data_file_name
    remove_column :assets, :data_updated_at
  end
end
