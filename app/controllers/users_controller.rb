class UsersController < ApplicationController

  before_action :authorize, :except => [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.admin = false

    if @user.save
      flash[:message] = 'New user created. You can now log in.'
      redirect_to session_index_url
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

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :company)
  end

end
