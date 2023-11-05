module TasksHelper

  # Generate a GeoJSON structure for the polygon.
  def make_polygon(polygon)
    polygon << polygon[0]
    geojson_polygon = Terraformer::Polygon.new([polygon])
    geojson_feature = geojson_polygon.to_feature
    geojson_collection = Terraformer::FeatureCollection.new
    geojson_collection << geojson_feature
    
    return geojson_collection
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
      :edus => options[:edus],
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

end
