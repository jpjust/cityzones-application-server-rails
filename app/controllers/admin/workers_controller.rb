class Admin::WorkersController < ApplicationController

  before_action :authorize_admin

  def index
    @workers = Worker.all
  end

  def new
    @worker = Worker.new
  end

  def create
    @worker = Worker.new(worker_params)
    @worker.tasks = 0
    @worker.total_time = 0
    @worker.token = SecureRandom.hex(32)
    
    if @worker.save
      flash[:message] = 'Worker created.'
      redirect_to admin_workers_path
    else
      render :new, :status => :unprocessable_entity
    end
  end

  def edit
    @worker = Worker.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = 'Worker not found.'
    redirect_to admin_workers_path
  end

  def update
    @worker = Worker.find(params[:id])

    if @worker.update(worker_params)
      flash[:message] = 'Worker updated.'
      redirect_to admin_workers_path
    else
      render :edit, :status => :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = 'Worker not found.'
    redirect_to admin_workers_path
  end

  def destroy
    @worker = Worker.find(params[:id])

    if @worker.destroy
      flash[:message] = 'Worker deleted.'
    else
      flash[:notice] = 'Error deleting worker.'
    end
    redirect_to admin_workers_path
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = 'Worker not found.'
    redirect_to admin_workers_path
  end

  private

  def worker_params
    params.require(:worker).permit(:name, :description)
  end

end
