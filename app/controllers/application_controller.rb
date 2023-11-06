class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionHelper 

  def authorize
    if logged_in?
      current_user.last_access_at = Time.now
      current_user.save
    else
      redirect_to new_session_url
    end
  end

  def authorize_admin
    if logged_in? && current_user.admin
      current_user.last_access_at = Time.now
      current_user.save
    else
      redirect_to new_task_url
    end
  end

  def authorize_worker
    @worker = Worker.find_by(token: request.headers['x-api-key'])
    
    if @worker.nil?
      render :json => { :msg => 'Unauthorized.' }, :status => 401
    end
  end

end
