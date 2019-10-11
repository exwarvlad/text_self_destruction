# frozen_string_literal: true

class MessageService
  attr_reader :token, :body, :expire_hours, :click_strike

  def initialize(params)
    @token = params[:token]
    @body = params[:body]
    @expire_hours = params[:expire_hours]
    @click_strike = params[:click_strike]
  end

  def call
    case true
    when timing?
      post_to_redis
    when striker?
      # todo
    end
  end

  def timing?
    expire_hours.present?
  end

  def striker?
    click_strike.present?
  end

  private

  def post_to_redis
    REDIS.set(token, body)
    REDIS.expire(token, expire_hours * 3600)
  end
end
