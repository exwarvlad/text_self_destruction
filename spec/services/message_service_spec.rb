require 'rspec'
require 'byebug'
require_relative '../../spec/helpers'
require_relative '../../config/redis'
require_relative '../../lib/validators/base_validator'
require_relative '../../lib/message'

describe '.call' do
  let!(:request_params) { {body: 'Very secret message!', expire_hours: 2} }
  let!(:message_params) { Message.new(request_params, BaseValidator.new).params }
  let!(:mutated_params) { MessageMutator.new(message_params).mutated_params }
  let(:message_service) { MessageService.new(mutated_params) }

  it '.call' do
    message_service.call
    redis_ttl_message = REDIS.ttl(message_service.token)
    redis_encrypted_message = REDIS.get(message_service.token)
    deciphered_message = decipher_message(redis_encrypted_message)

    expect(redis_encrypted_message).not_to eq(request_params[:body])
    expect(deciphered_message).to eq(request_params[:body])
    expect(redis_ttl_message).to eq(request_params[:expire_hours] * 3600)
  end
end
