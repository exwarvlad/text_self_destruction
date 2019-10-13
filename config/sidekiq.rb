# frozen_string_literal: true

require 'sinatra'
require_relative '../main'

REDIS_URL = ENV['REDIS_URL'] || 'redis://localhost:6379/2'

Sidekiq.configure_server do |config|
  config.redis = { url: REDIS_URL}
end

Sidekiq.configure_client do |config|
  config.redis = { url: REDIS_URL, size: 1 }
end
