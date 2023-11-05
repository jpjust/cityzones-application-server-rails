class CellType < ApplicationRecord

  has_many :cells

  validates :name, :presence => true

end
