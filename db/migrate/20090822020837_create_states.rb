class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.string :name, :limit => 16
      t.string :type, :limit => 16
      t.string :description
    end
  end

  def self.down
    drop_table :states
  end
end