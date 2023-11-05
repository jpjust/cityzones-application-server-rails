class Api::CellsController < ApplicationController

  protect_from_forgery with: :null_session
  before_action :authorize_worker

  def index
    left   = params[:left].to_f
    right  = params[:right].to_f
    top    = params[:top].to_f
    bottom = params[:bottom].to_f
    wkt_string = "POLYGON((#{left} #{bottom}, #{left} #{top}, #{right} #{top}, #{right} #{bottom}, #{left} #{bottom}))"
    q = ActiveRecord::Base.connection.exec_query("SELECT id, X(coord), Y(coord), cell_type_id, radius FROM cells WHERE MBRContains(ST_GeomFromText('#{wkt_string}'), coord)")
    render :json => q
  end

end
