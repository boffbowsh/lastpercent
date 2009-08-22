class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.integer :user_id,           :limit => 2
      t.string :verification_token, :limit => 32
      t.string :url
      t.datetime :verified_at
      t.timestamps
      t.datetime :deleted_at
    end
  end

  def self.down
    drop_table :sites
  end
end