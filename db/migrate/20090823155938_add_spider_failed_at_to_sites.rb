class AddSpiderFailedAtToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :spider_failed_at, :datetime
  end

  def self.down
    remove_column :sites, :spider_failed_at
  end
end
