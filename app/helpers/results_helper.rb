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

end
