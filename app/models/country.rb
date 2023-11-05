class Country < ApplicationRecord

  def coord
    "#{self.lat},#{self.lon}"
  end

end
