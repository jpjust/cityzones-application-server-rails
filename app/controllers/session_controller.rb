class SessionController < ApplicationController

  before_action :block_access, except: [:destroy]

  def new
  end

  def create
    @user = User.find_by(email: session_params[:email].try(:downcase))
    if @user && @user.authenticate(session_params[:password])
      sign_in @user
      redirect_to new_task_url
    else
      flash[:notice] = 'Authentication failure!'
      render :new, :status => :unprocessable_entity
    end
  end

  def destroy
    sign_out
    redirect_to new_session_url
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end

end
