require 'rspec'
require_relative '../../lib/services/body_service'
require_relative '../../spec/helpers'
require_relative '../../config/redis'
require_relative '../../lib/message'

describe '.call' do
  it 'when timing' do
    params = {body: 'timing expire message', expire_hours: 2}
    message = Message.new(params)
    message_service = MessageService.new(message.params)
    message_service.call
    body_response = BodyService.new(message_service.token).call

    expect(body_response).to eq message.params[:body]
  end

  it 'when fake timing' do
    params = {body: 'I am not', expire_hours: 1}
    expired_token = TokenMutator.new(params).call
    body_response = BodyService.new(expired_token).call

    expect(body_response).to eq nil
  end

  it 'when striking' do
    params = {body: 'I am striker', click_striker: 2}
    message = Message.new(params)
    message_service = MessageService.new(message.params)
    message_service.call
    body_service = BodyService.new(message_service.token)

    params[:click_striker].times { expect(body_service.call).to eq params[:body] }
    expect(body_service.call).to eq nil
  end

  it 'when fake striking' do
    params = {body: 'I am not', click_striker: 1}
    expired_token = TokenMutator.new(params).call
    body_response = BodyService.new(expired_token).call

    expect(body_response).to eq nil
  end

  it 'when timing and striker' do
    params = {body: 'I have time and strike', expire_hours: 2, click_striker: 2}
    message = Message.new(params)
    message_service = MessageService.new(message.params)
    message_service.call
    body_service = BodyService.new(message_service.token)

    params[:click_striker].times { expect(body_service.call).to eq params[:body] }
    expect(body_service.call).to eq nil
  end
end
