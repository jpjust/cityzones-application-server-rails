class Api::OpenElevationController < ApplicationController

  require 'net/http'
  require 'net/https'

  protect_from_forgery with: :null_session
  before_action :authorize_worker

  def lookup
    http = Net::HTTP.new('localhost', 8080)
    headers = {
      'Content-type': 'application/json',
      'User-Agent': 'Mozilla/5.0 (Linux) CityZones/2.0 AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36'
    }

    begin
      res = http.request_post('/api/v1/lookup', params[:query].to_json, headers)
      if res.is_a? Net::HTTPOK
        render :json => res.body
      else
        render :json => {}, :status => 502
      end
    rescue EOFError
      render :json => { :results => [] }
    rescue Timeout::Error, SocketError, Errno::ECONNREFUSED, Errno::ECONNRESET
      render :json => {}, :status => 500
    end
  end

end
