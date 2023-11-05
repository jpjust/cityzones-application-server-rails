class Task < ApplicationRecord

  belongs_to :user

  has_one :result

  validates :base_filename, :config, :geojson, :lat, :lon, :requests, :presence => true
  validates :base_filename, :uniqueness => true
  validates :requests, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }

  default_scope { order(created_at: :desc) }

  attribute :polygon

  def config_to_json
    JSON.parse self.config
  end

  def geojson_to_json
    JSON.parse self.geojson
  end

  def pois
    pois_list = []
    self.config_to_json['pois_types'].keys.each do |poi_category|
      self.config_to_json['pois_types'][poi_category].keys.each do |poi|
        pois_list << {
          :name => poi,
          :w => self.config_to_json['pois_types'][poi_category][poi]['w'].to_i
        }
      end
    end
    pois_list
  end

  def expired?
    return false if self.requested_at.nil?

    request_exp = Time.now - ENV['TASK_REQ_EXP'].to_i.minutes
    return self.requested_at < request_exp
  end
  
  def failed?
    self.expired? && self.requests >= ENV['TASK_REQ_MAX'].to_i
  end

end
