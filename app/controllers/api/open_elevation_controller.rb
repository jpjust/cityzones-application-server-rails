class Api::OpenElevationController < ApplicationController

  require 'net/http'
  require 'net/https'

  protect_from_forgery with: :null_session

  def lookup
    http = Net::HTTP.new('localhost', 8081)
    headers = {
      'Content-type': 'application/json'
    }

    begin
      res = http.request_post('/api/v1/lookup', params[:query].to_json, headers)
      if res.is_a? Net::HTTPOK
        render :json => res.body
      else
        render :json => {}, :status => 502
      end
    rescue Timeout::Error, SocketError, Errno::ECONNREFUSED, Errno::ECONNRESET
      render :json => {}, :status => 500
    end
  end

end
