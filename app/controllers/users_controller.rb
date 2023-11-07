class UsersController < ApplicationController

  include SessionHelper
  include TasksHelper

  before_action :authorize, :except => [:new, :create]
  before_action :block_access, except: [:edit, :update, :destroy]

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
    
    # Delete all map data, results and tasks
    current_user.tasks.each do |task|
      delete_task(task)
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
