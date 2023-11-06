class Result < ApplicationRecord

  belongs_to :task

  def res_data_to_json
    self.res_data.is_a?(Hash) ? self.res_data : JSON.parse(self.res_data)
  end

end
