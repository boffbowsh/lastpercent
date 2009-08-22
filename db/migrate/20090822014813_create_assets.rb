class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.integer     :site_id, :limit => 2
      t.boolean     :external
      t.integer     :content_type_id, :limit => 1
      t.integer     :responce_status, :limit => 2
      t.integer     :responce_time, :limit => 2
      t.datetime    :created_at
      t.string      :url
    
    end
    
    add_index :assets, :site_id
  end
  

  def self.down
    remove_index :assets, :site_id
    drop_table :assets    
  end
end
