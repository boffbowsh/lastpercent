class CreateValidators < ActiveRecord::Migration
  def self.up
    create_table :validators do |t|
      t.boolean :active
      t.string :class_name
      t.string :name
      t.string :description
      t.string :permalink
    end
  end

  def self.down
    drop_table :validators
  end
end