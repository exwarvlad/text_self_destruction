# frozen_string_literal: true

require 'sinatra'
require 'redis'
require 'uri'

REDISTOGO_URL = 'redis://localhost:6379/3'

configure do
  uri = URI.parse(REDISTOGO_URL)
  REDIS = Redis.new(host: uri.host, port: uri.port, password: uri.password)
end
