class AddBodyToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :body, :text
  end

  def self.down
    remove_column :assets, :body
  end
end
