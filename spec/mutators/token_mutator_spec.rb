# frozen_string_literal: true

require 'rspec'
require_relative '../../lib/mutators/token_mutator'

describe 'TokenMutator methods' do
  let(:params) { {expire_hours: 2} }

  it '.call and .find_time_by_token' do
    token = TokenMutator.new(params).call

    # expect expire token time
    expect((Time.now + params[:expire_hours].hour).to_i).to eq TokenMutator.find_time_by_token(token).to_i
  end
end
