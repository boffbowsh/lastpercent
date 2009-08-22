class Asset < ActiveRecord::Base
    
  has_and_belongs_to_many :links, 
                          :class_name => "Asset",
                          :join_table => "links", 
                          :foreign_key => "from_asset_id",
                          :association_foreign_key => "to_asset_id"
                          
  validates_uniqueness_of :url
  
  
end
