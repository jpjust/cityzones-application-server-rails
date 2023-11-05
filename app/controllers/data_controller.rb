class DataController < ApplicationController

  before_action :authorize
  
  def index
    task = Task.find(params[:task_id])

    if task.user.id != current_user.id
      render :json => {}, :status => 404
      return
    end

    map_file = "#{ENV['RESULTS_DIR']}/#{task.result.task.base_filename}_map.csv"
    edus_file = "#{ENV['RESULTS_DIR']}/#{task.result.task.base_filename}_edus.csv"
    roads_file = "#{ENV['RESULTS_DIR']}/#{task.result.task.base_filename}_roads.csv"
    zip_file = "#{ENV['TMP_DIR']}/#{task.result.task.base_filename}_results.zip"

    File.delete(zip_file) if File.file?(zip_file)

    unless File.file?(map_file)
      render :json => { :msg => 'The map file for this task is missing!' }, :status => 404
      return
    end
    
    Archive::Zip.archive(zip_file, map_file)
    Archive::Zip.archive(zip_file, edus_file)  if File.file?(edus_file)
    Archive::Zip.archive(zip_file, roads_file) if File.file?(roads_file)

    send_file(zip_file, { :filename => "#{task.result.task.base_filename}_results.zip" })
  end

end
