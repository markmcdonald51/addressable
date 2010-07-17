class AddressMigration < ActiveRecord::Migration
  def self.up
    create_table "addresses", :force => true do |t|
      t.column "street_address", :string
      t.column "apt", :string
      t.column "city", :string
      t.column "postal_code", :string
      t.column "region", :string
      t.column "country", :string
      t.column "contact_full_name", :string
      t.column "contact_email", :string
      t.column "business_phone_number", :string
      t.column "fax_phone_number", :string
      t.column "lat", :decimal, :precision => 15, :scale => 10
      t.column "lng", :decimal, :precision => 15, :scale => 10
      t.column "addressable_id", :integer
      t.column "addressable_type", :string
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "skype_name", :string
      t.column "mobile_phone_number", :string
      t.column "website", :string
      t.column "geom", :point, :srid => 4326
      t.column "geo_accuracy", :integer
    end

    add_index "addresses", ["addressable_id", "addressable_type"], :name => "index_addresses_on_addressable_id_and_addressable_type"
    add_index "addresses", ["geom"], :name => "index_addresses_on_geom", :spatial=> true 
    add_index "addresses", ["lat", "lng"], :name => "index_addresses_on_lat_and_lng"

  end    
  
  def self.down
    drop_table :addresses
  end  
end
