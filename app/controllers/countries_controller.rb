class CountriesController < ApplicationController

  before_action :authorize
  
  def index
    render :json => Country.all
  end

end
