# frozen_string_literal: true

require 'sinatra'
require 'dotenv/load'
require 'sinatra/activerecord'
require 'byebug'
require_relative 'lib/click_striker'
require_relative 'config/redis'
require_relative 'lib/message'

get '/' do
  slim :index
end

get '/message/*' do
  slim :show
end

post '/message/create' do
  message = Message.new(params, BaseValidator.new)

  if message.valid
    MessageService.new(message.params).call
    # todo
    # render token
  else
    # todo
    # render forbidden
  end
end
