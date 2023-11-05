class Result < ApplicationRecord

  belongs_to :task

  def res_data_to_json
    JSON.parse self.res_data
  end

end
