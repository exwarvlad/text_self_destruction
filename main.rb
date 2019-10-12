# frozen_string_literal: true

require 'sinatra'
require 'dotenv/load'
require 'sinatra/activerecord'
require 'byebug'
require 'thin'
require 'sidekiq'
require_relative 'config/sidekiq'
require_relative 'lib/click_striker'
require_relative 'config/redis'
require_relative 'lib/message'
require_relative 'lib/services/body_service'
require_relative 'lib/workers/dead_shot_worker'

get '/' do
  slim :index
end

get '/token' do
  slim :token
end

get '/message/*' do
  token = request.path.split('/').last
  message = BodyService.new(token).call

  if message
    slim :show, locals: {message: message}
  else
    status 404
    body 'not found'
  end
end

post '/message/create' do
  message = Message.new(params, BaseValidator.new)

  if message.valid
    message_service = MessageService.new(message.params)
    message_service.call

    redirect "/token?token=#{message_service.token}"
  else
    client_status_error = 'Client Error'
    status 453
    Thin::HTTP_STATUS_CODES[453] = client_status_error
    body client_status_error
  end
end
