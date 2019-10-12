require 'sinatra'
# require 'dotenv/load'
# require 'sinatra/activerecord'
# require_relative '../lib/workers/dead_shot_worker'
# require_relative 'redis'
require_relative '../main'

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/2' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/2' }
end
