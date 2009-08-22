class CreateContentTypes < ActiveRecord::Migration
  def self.up
    create_table :content_types do |t|
      t.string :mime_type
    end
  end

  def self.down
    drop_table :content_types
  end
end