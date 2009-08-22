class AddMoreIndexes < ActiveRecord::Migration
  def self.up
    add_index :assets, :content_type_id
    add_index :assets, [:site_id, :url], :unique => true
  end

  def self.down
    remove_index :assets, :content_type_id
    remove_index :assets, [:site_id, :url]
  end
end