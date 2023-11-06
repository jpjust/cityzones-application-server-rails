class UsersController < ApplicationController

  include SessionHelper

  before_action :authorize, :except => [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.admin = false

    if @user.save
      flash[:message] = 'New user created. You can now log in.'
      redirect_to new_session_url
    else
      render :new, :status => :unprocessable_entity
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    
    if @user.update(user_params)
      flash[:message] = 'User data updated.'
      redirect_to new_task_url
    else
      render :edit, :status => :unprocessable_entity
    end
  end

  def destroy
    user = current_user
    data_types = ['map', 'edus', 'roads']

    # Delete all map data, results and tasks
    current_user.tasks.each do |task|
      if task.result.present?
        data_types.each do |type|
          filename = File.join(ENV['RESULTS_DIR'], "#{task.base_filename}_#{type}.csv")
          Rails.logger.info "[User deletion] Deleting file #{filename}"
          File.delete(filename) if File.file?(filename)
        end
        task.result.destroy!
      end
      task.destroy!
    end

    # Delete any password recovery token
    current_user.password_recoveries.each do |pr|
      pr.destroy!
    end

    sign_out
    user.destroy!

    flash[:message] = 'User permanently deleted.'
    redirect_to new_session_url
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :company)
  end

end
