module ResultsHelper

  def extract_polygon_from_geojson(geojson)
    geojson_geometry = geojson['features'][0]['geometry']
    
    case geojson_geometry['type']
    when 'Polygon'
      polygon = geojson_geometry['coordinates'][0]
    when 'MultiPolygon'
      polygon = geojson_geometry['coordinates'][0][0]
    end

    return polygon
  end

  def delete_result(result)
    data_types = ['map', 'edus', 'roads']

    data_types.each do |type|
      filename = File.join(ENV['RESULTS_DIR'], "#{result.task.base_filename}_#{type}.csv")
      Rails.logger.info "[Result deletion] Deleting file #{filename}"
      File.delete(filename) if File.file?(filename)
    end
    result.destroy!
  end

end
