class AddIndexes < ActiveRecord::Migration
  def self.up
    rename_column :checks, :worked_id, :worker_id

    add_index :sites, :user_id
    add_index :sites, :verification_token
    
    add_index :validators, :active
    add_index :validators, :class_name, :unique => true
    add_index :validators, :permalink, :unique => true
    
    add_index :checks, :asset_id
    add_index :checks, :validator_id
    add_index :checks, :worker_id
    add_index :checks, [:asset_id, :validator_id]
    
    add_index :workers, :state_id
    
    add_index :results, :asset_id
    add_index :results, :check_id
    add_index :results, :message_id
    add_index :results, :severity
    
    add_index :messages, :validator_id
    
    add_index :content_types, :mime_type, :unique => :true
    
    add_index :states, [:name, :type], :unqiue => true
  end

  def self.down
  end
end