# frozen_string_literal: true

require 'sinatra'
require 'redis'
require 'uri'

case ENV['RACK_ENV']
when 'development'
  REDISTOGO_URL = 'redis://localhost:6379/0'
when 'test'
  REDISTOGO_URL = 'redis://localhost:6379/1'
end

configure do
  uri = URI.parse(REDISTOGO_URL)
  REDIS = Redis.new(host: uri.host, port: uri.port, password: uri.password)
end
