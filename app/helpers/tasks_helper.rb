module TasksHelper

  include ResultsHelper

  # Generate a GeoJSON structure for the polygon.
  def make_polygon(polygon)
    polygon << polygon[0]
    geojson = {
      :type => 'FeatureCollection',
      :features => [{
        :type => 'Feature',
        :geometry => {
          :type => 'Polygon',
          :coordinates => [polygon]
        },
        :properties => {}
      }]
    }
  
    return geojson
  end

  # Generate a JSON configuration for the riskzones rool.
  def make_config_file(options = { :polygon => [], :zl => 30, :edus => 300, :edu_alg => :none })
    timestamp = Time.now.strftime('%Y%m%d%H%M%S%N')
    base_filename = "task_#{timestamp}"

    # Calculate AoI boundaries
    left = right = options[:polygon][0][0]
    top = bottom = options[:polygon][0][1]

    options[:polygon].each do |point|
      left   = point[0] if point[0] < left
      right  = point[0] if point[0] > right
      bottom = point[1] if point[1] < bottom
      top    = point[1] if point[1] > top
    end
    
    # Increase grid box by 10% each side (to get PoIs outside)
    width = (right - left).abs
    height = (top - bottom).abs
    left -= width * 0.1
    right += width * 0.1
    top += height * 0.1
    bottom -= height * 0.1
    
    base_conf = {
      :base_filename => base_filename,
      :left => left,
      :bottom => bottom,
      :right => right,
      :top => top,
      :zone_size => options[:zl],
      :cache_zones => false,
      :M => ENV['RZ_M'].to_i,
      :edus => {
        :loose => options[:edus],
        :tight => 0
      },
      :geojson => "#{base_filename}.geojson",
      :pois => "#{base_filename}.osm",
      :pois_use_all => false,
      :pois_types => {
          :amenity => {},
          :railway => {}
      },
      :edu_alg => options[:edu_alg],
      :output => "#{base_filename}_map.csv",
      :output_edus => "#{base_filename}_edus.csv",
      :output_roads => "#{base_filename}_roads.csv",
      :res_data => "#{base_filename}_res_data.json",
    }

    return base_filename, base_conf
  end

  # Create a task from form data
  def create_task
    # Geographical data
    geojson_fc = make_polygon(eval(task_params[:polygon]))
    base_filename, conf = make_config_file(
      :polygon => eval(task_params[:polygon]),
      :zl      => task_params[:zl].to_i,
      :edus    => task_params[:edus].to_i,
      :edu_alg => task_params[:edu_alg]
    )
    center_lon = (conf[:left] + conf[:right]) / 2
    center_lat = (conf[:bottom] + conf[:top]) / 2
    
    # PoIs configuration
    conf[:pois_use_all] = task_params[:pois_use_all]
    conf[:pois_types][:amenity][:hospital]     = { :w => task_params[:w_hospital].to_i } if task_params[:poi_hospital].to_i == 1
    conf[:pois_types][:amenity][:fire_station] = { :w => task_params[:w_firedept].to_i } if task_params[:poi_firedept].to_i == 1
    conf[:pois_types][:amenity][:police]       = { :w => task_params[:w_police].to_i } if task_params[:poi_police].to_i == 1
    conf[:pois_types][:railway][:station]      = { :w => task_params[:w_metro].to_i } if task_params[:poi_metro].to_i == 1
    
    # Task creation
    @task = Task.create!({
      user_id: current_user.id,
      base_filename: base_filename,
      config: conf.to_json,
      geojson: geojson_fc.to_json,
      lat: center_lat.to_f,
      lon: center_lon.to_f,
      description: task_params[:description],
      requests: 0
    })
  end

  # Delete a task and its results
  def delete_task(task)
    delete_result(task.result) if task.result.present?
    task.destroy!
  end

end
