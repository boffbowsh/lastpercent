class CreateContentTypesValidatorsTable < ActiveRecord::Migration
  def self.up
    create_table :content_types_validators, :force => true, :id => false do |t|
      t.integer :content_type_id
      t.integer :validator_id
    end
  end

  def self.down
    drop_table :content_types_validators
  end
end
