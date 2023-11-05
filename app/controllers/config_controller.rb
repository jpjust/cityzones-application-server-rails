class ConfigController < ApplicationController

  before_action :authorize
  
  def index
    task = Task.where(id: params[:task_id], user_id: current_user.id).first

    unless task.present?
      render :json => {}, :status => 404
    end

    send_data(task.config, { :filename => "#{task.base_filename}_config.json" })
  end

end
