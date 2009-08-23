class AddJobTypeToJob < ActiveRecord::Migration
  def self.up
    add_column :delayed_jobs, :job_type, :string
  end

  def self.down
    remove_column :delayed_jobs, :job_type
  end
end
