class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links, :id => false do |t|
      t.integer :from_asset_id
      t.integer :to_asset_id
    end
    
    add_index :links, [:from_asset_id, :to_asset_id]
    add_index :links, [:to_asset_id, :from_asset_id]
  end

  def self.down
    remove_index :links, [:from_asset_id, :to_asset_id]
    remove_index :links, [:to_asset_id, :from_asset_id]
    drop_table :links
  end
end
