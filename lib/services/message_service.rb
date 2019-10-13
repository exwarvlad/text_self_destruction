# frozen_string_literal: true

require 'base64'
require_relative '../../lib/mutators/message_mutator'

class MessageService
  attr_reader :token, :body, :expire_hours, :click_striker

  def initialize(message_params)
    params = MessageMutator.new(message_params).mutated_params
    @token = params[:token]
    @body = params[:body]
    @expire_hours = params[:expire_hours]
    @click_striker = params[:click_striker]
  end

  def call
    case true
    when striker? && timing?
      jid = DeadShotWorker.perform_at(expire_hours.hours.from_now, token)
      ClickStriker.create(slug: token, counter: click_striker, jid: jid)
      post_to_redis
    when timing?
      post_to_redis
    when striker?
      ClickStriker.create(slug: token, counter: click_striker, body: body)
      REDIS.set(token, body)
    end
  end

  def timing?
    expire_hours.positive?
  end

  def striker?
    click_striker.positive?
  end

  private

  def post_to_redis
    REDIS.set(token, body)
    REDIS.expire(token, expire_hours * 3600)
  end
end
