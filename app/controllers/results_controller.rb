class ResultsController < ApplicationController

  require 'csv'
  include ResultsHelper

  before_action :authorize

  def index
    task = Task.find(params[:task_id])
    
    if task.user.id != current_user.id
      render :json => {}, :status => 404
      return
    end

    # Prepare classification results JSON
    classification = {
      :polygon => [],
      :center_lat => 0,
      :center_lon => 0,
      :zl => task.config_to_json['zone_size'],
      :M => ENV['RZ_M'].to_i,
      :classes => {},
      :edus => []
    }

    (1..ENV['RZ_M'].to_i).each do |m|
      classification[:classes]["class_#{m}"] = { :points => [] }
    end

    left = 180
    right = -180
    bottom = 90
    top = -90
    classification[:polygon] = extract_polygon_from_geojson(task.geojson_to_json)

    # Classification data
    map_file = "#{ENV['RESULTS_DIR']}/#{task.base_filename}_map.csv"
    edus_file = "#{ENV['RESULTS_DIR']}/#{task.base_filename}_edus.csv"
    
    # Classification CSV
    map_csv = CSV.read(map_file, :headers => true)
    map_csv.each do |row|
      if row['RL'].present?
        # In case of a 'RL' column, it means this is the new format
        m = row['RL']
        coord = [row['lon'].to_f, row['lat'].to_f]
      else row['class'].present?
        # Otherwise it is the old format
        m = row[1]
        geodata = JSON.parse(row[2])
        coord = geodata['coordinates']
      end
      classification[:classes]["class_#{m}"][:points] << coord

      left   = coord[0] if coord[0] < left
      right  = coord[0] if coord[0] > right
      bottom = coord[1] if coord[1] < bottom
      top    = coord[1] if coord[1] > top
    end

    classification[:center_lat] = (bottom + top) / 2
    classification[:center_lon] = (left + right) / 2

    # EDUs CSV
    edus_csv = CSV.read(edus_file, :headers => true)
    edus_csv.each do |row|
      if row['type'].present?
        # In case of a 'type' column, it means this is the new format
        coord = [row['lon'].to_f, row['lat'].to_f]
      else
        # Otherwise it is the old format
        geodata = JSON.parse(row[1])
        coord = geodata['coordinates']
      end
      classification[:edus] << coord
    end

    render :json => classification
  rescue ActiveRecord::RecordNotFound
    render :json => {}, :status => 404
  end

end
