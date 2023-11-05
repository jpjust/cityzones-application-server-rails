class Cell < ApplicationRecord

  belongs_to :cell_type

  validates :coord, :radius, :presence => true
  
  # set_rgeo_factory_for_column(:coord, RGeo::Geographic.spherical_factory(:srid => 4326))

end
