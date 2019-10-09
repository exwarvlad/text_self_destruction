# frozen_string_literal: true

require 'sinatra'
require 'byebug'
require_relative 'lib/message'

get '/' do
  slim :index
end

get '/message/*' do
  slim :show
end

post '/message/create' do
  Message.new(params, BaseValidator.new).call
end
