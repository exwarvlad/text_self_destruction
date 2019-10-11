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

  it '.striker?' do
    token1 = TokenMutator.new(params).call
    params[:click_striker] = 2
    token2 = TokenMutator.new(params).call

    expect(TokenMutator.striker?(token1)).to eq false
    expect(TokenMutator.striker?(token2)).to eq true
  end

  it 'base token' do
    token = TokenMutator.new({}).call

    expect(TokenMutator.find_time_by_token(token)).to eq nil
    expect(TokenMutator.striker?(token)).to eq false
  end
end
