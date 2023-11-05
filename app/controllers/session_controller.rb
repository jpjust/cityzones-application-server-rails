class SessionController < ApplicationController

  before_action :block_access, except: [:index, :destroy]

  def index
  end

  def create
    @user = User.find_by(email: session_params[:email].try(:downcase))
    if @user && @user.authenticate(session_params[:password])
      sign_in @user
      redirect_to :controller => :tasks, :action => :new
    else
      flash[:notice] = 'Authentication failure!'
      render :index, :status => :unprocessable_entity
    end
  end

  def destroy
    sign_out
    redirect_to :controller => :session, :action => :index
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end

end
