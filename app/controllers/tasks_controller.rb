class TasksController < ApplicationController

  include TasksHelper
  include ResultsHelper

  before_action :authorize
  
  def index
    @tasks = Task.where(user_id: current_user.id).includes(:result)
  end

  def new
    @task = Task.new
    @task.lat = ENV['DEFAULT_MAP_LAT']
    @task.lon = ENV['DEFAULT_MAP_LON']
    @task.polygon = '[]'
  end

  def create
    if request.post? && task_params[:geojson_file].present?
      geojson = JSON.parse(task_params[:geojson_file].read)
      polygon = extract_polygon_from_geojson(geojson)
      @task = Task.new
      @task.polygon = polygon.to_s
      @task.lon = polygon[0][0]
      @task.lat = polygon[0][1]
      render :new
      return
    end

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
      lat: task_params[:lat].to_f,
      lon: task_params[:lon].to_f,
      description: task_params[:description],
      requests: 0
    })
    
    flash[:message] = "Task ##{@task.id} created."
    redirect_to tasks_url
  end

  def destroy
    task = Task.where(id: params[:id], user_id: current_user.id).first

    unless task.present?
      render :json => {}, :status => 404
      return
    end

    delete_task(task)
    redirect_to tasks_url
  end

  private

  def task_params
    params.require(:task).permit(:polygon, :lat, :lon, :zl, :pois_use_all, :poi_hospital, :w_hospital, :poi_firedept, :w_firedept,
                                 :poi_police, :w_police, :poi_metro, :w_metro, :edus, :edu_alg, :description, :geojson_file)
  end

end
