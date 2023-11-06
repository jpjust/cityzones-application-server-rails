class Api::TasksController < ApplicationController

  protect_from_forgery with: :null_session
  before_action :authorize_worker

  def index
    request_exp = Time.now - ENV['TASK_REQ_EXP'].to_i.minutes
    task = Task.includes(:result)
               .where('requests < ?', ENV['TASK_REQ_MAX'])
               .where('requested_at IS NULL OR requested_at < ?', request_exp)
               .reject{ |t| t.result.present? }
               .first
    
    if task.present?
      task.requested_at = Time.now
      task.requests += 1
      task.save!

      render :json => {
        :id => task.id,
        :config => task.config_to_json,
        :geojson => task.geojson_to_json
      }
    else
      render :json => {}, :status => 204
    end
  end

  def update
    task = Task.find(params[:id])
    
    if task.result.present?
      render :json => { :msg => 'There is a result for this task already.' }, :status => 422
      return
    end

    task_params[:data].keys.each do |data_name|
      uploaded_file = task_params[:data][data_name]
      File.open(Rails.root.join(ENV['RESULTS_DIR'], "#{task.base_filename}_#{data_name}.csv"), 'wb') do |file|
        file.write(uploaded_file.read)
      end
    end

    res_data = task_params[:res_data].read
    res_data_json = JSON.parse(res_data)

    result = Result.create!({
      task_id: task.id,
      res_data: res_data
    })

    @worker.tasks += 1
    @worker.last_task_at = Time.now
    @worker.total_time += res_data_json['time_classification'].to_f + res_data_json['time_positioning'].to_f
    @worker.save

    render :json => {}, :status => 201
  rescue ActiveRecord::RecordNotFound
    render :json => {}, :status => 404
  end

  private

  def task_params
    params.require(:task).permit(:res_data, :data => [:map, :edus, :roads])
  end

end
