class AddSpiderStartedAtAndSpiderEndedAtToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :spider_started_at, :datetime
    add_column :sites, :spider_ended_at, :datetime
  end

  def self.down
    remove_column :sites, :spider_started_at
    remove_column :sites, :spider_ended_at
  end
end
