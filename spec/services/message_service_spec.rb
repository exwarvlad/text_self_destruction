# frozen_string_literal: true

require 'rspec'
require 'byebug'
require_relative '../../spec/helpers'
require_relative '../../config/redis'
require_relative '../../lib/validators/base_validator'
require_relative '../../lib/message'

describe '.call' do
  let(:request_params) { {body: 'Very secret message!'} }

  it '.call when timing' do
    request_params[:expire_hours] = 2
    message_service = MessageService.new(Message.new(request_params).params)
    message_service.call
    redis_ttl_message = REDIS.ttl(message_service.token)
    redis_encrypted_message = BodyMutator.encode_ascii(REDIS.get(message_service.token))
    deciphered_message = BodyMutator.decipher_message(redis_encrypted_message)

    expect(redis_encrypted_message).not_to eq(request_params[:body])
    expect(deciphered_message).to eq(request_params[:body])
    expect(redis_ttl_message).to eq(request_params[:expire_hours] * 3600)
    expect(ClickStriker.find_by_slug(message_service.token)).to eq nil
  end

  it '.call when striker' do
    request_params[:click_striker] = 2
    message_service = MessageService.new(Message.new(request_params).params)
    message_service.call
    click_striker = ClickStriker.find_by_slug(message_service.token)

    expect(click_striker.counter).to eq 2
    expect(click_striker.body).to eq nil
  end

  it '.call when timing and striking' do
    request_params[:expire_hours] = 2
    request_params[:click_striker] = 2
    message_service = MessageService.new(Message.new(request_params).params)
    message_service.call
    click_striker = ClickStriker.find_by_slug(message_service.token)
    pg_encrypted_message = BodyMutator.encode_ascii(click_striker.body)
    deciphered_message = BodyMutator.decipher_message(pg_encrypted_message)

    expect(click_striker.counter).to eq request_params[:click_striker]
    expect(click_striker.body).to_not eq request_params[:body]
    expect(deciphered_message).to eq request_params[:body]
  end
end
