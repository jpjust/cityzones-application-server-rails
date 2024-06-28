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

    create_task
    flash[:message] = "Task ##{@task.id} created."
    redirect_to tasks_url
  end

  def edit
    @task = Task.where(id: params[:id], user_id: current_user.id).first

    unless @task.present?
      flash[:notice] = 'Task not found.'
      redirect_to tasks_url
      return
    end

    @task.polygon = @task.geojson_to_json['features'][0]['geometry']['coordinates'][0].to_s
  end

  def update
    create_task
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
                                 :poi_police, :w_police, :poi_metro, :w_metro, :edus, :edu_alg, :description, :geojson_file,
                                 :risk_flood, :flood_level)
  end

end
