class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string   :email,                             :null => false
      t.string   :crypted_password
      t.string   :password_salt
      t.string   :persistence_token,                 :null => false
      t.integer  :login_count,        :default => 0, :null => false
      t.integer  :failed_login_count, :default => 0, :null => false
      t.datetime :last_request_at
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string   :current_login_ip
      t.string   :last_login_ip
      t.string   :perishable_token
      t.datetime :deleted_at
      t.datetime :activated_at
      t.string   :first_name
      t.string   :last_name
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :openid_identifier
    end
  end

  def self.down
    drop_table :users
  end
end
