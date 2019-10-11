require 'dotenv/load'
require 'sinatra/activerecord'
require 'base64'
require_relative '../lib/click_striker'

ENV['RACK_ENV'] ||= 'test'
