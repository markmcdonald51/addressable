class Address < ActiveRecord::Base
  include Geokit::Geocoders   
  acts_as_geom :geom => :point  
  acts_as_mappable
  belongs_to :addressable, :polymorphic => true
  
  validate :valid_address
  attr_accessor :result, :address_string
  

  def valid_address
    @address_string ||= [:street_address, :city, :region, :postal_code, :country].map{|f|
       self.send(f)}.join(',')
    
    res = MultiGeocoder.geocode(@address_string) #, :bias => country)

    if (res.success && res.accuracy >= 5) 
      if res.accuracy  == 8 #res.precision.to_sym == :address
        self.street_address = res.street_address
        self.city = res.city
        self.region = res.state
        self.postal_code 	= res.zip.gsub(/\s+/,'') unless res.zip.nil? 
      end      
      if res.lat && res.lng
        self.lat = res.lat
        self.lng = res.lng  
        self.geom = Point.from_x_y(self.lat,self.lng)
        self.geo_accuracy = res.accuracy
      end 
         
    else
      #errors.add_to_base('Sorry the address is not valid')
      #TODO: add this to controller...
      #flash[:notice] =  'WARNING! BTW, that address is not valid (says google)'
    end  
    
  end

#PER_PAGE =10

=begin
  define_index do
    # fields
    indexes :street_address
    indexes :postal_code
    indexes addressable.name
    
    # attributes
    has 'RADIANS(lat)', :as => :lat,  :type => :float    
    has 'RADIANS(lng)', :as => :lng,  :type => :float 
       
    # properties
    set_property :latitude_attr  => 'lat'
    set_property :longitude_attr => 'lng'

  end
=end
  
  
  def label
    [street_address, city, region, postal_code].reject{|v| v.blank?}.join(', ')
  end

end
