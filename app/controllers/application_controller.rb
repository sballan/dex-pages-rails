class ApplicationController < ActionController::API
  before_action :authenticate

  def authenticate
    dev_auth_token = ENV['DEV_AUTH_TOKEN']
    request_dev_auth_token = request.headers['Dev-Auth-Token']

    if dev_auth_token.blank?
      raise 'SERVER ERROR: no dev auth token'
    elsif request_dev_auth_token.blank?
      raise 'This app currently requiers a dev auth token in the request header'
    elsif dev_auth_token != request_dev_auth_token
      raise 'invalid dev auth token'
    end
  end

end
