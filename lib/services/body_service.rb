require 'sidekiq'
require_relative '../../lib/mutators/token_mutator'
require_relative '../../lib/workers/dead_shot_worker'

class BodyService
  attr_reader :token

  def initialize(token)
    @token = token
  end

  def call
    case true
    when TokenMutator.timing?(token) && TokenMutator.striker?(token)
      find_from_pg_and_redis
    when TokenMutator.timing?(token)
      return if TokenMutator.find_time_by_token(token) <= Time.now

      body = REDIS.get(token)
      BodyMutator.decipher_message(body) if body
    when TokenMutator.striker?(token)
      find_from_pg_and_redis
    end
  end

  private

  def find_from_pg_and_redis
    click_striker = ClickStriker.find_by_slug(token)
    return if click_striker.nil?

    click_striker.update(counter: click_striker.counter - 1)

    if click_striker.counter >= 0
      decrypted_message = BodyMutator.decipher_message(REDIS.get(token))
      DeadShotWorker.perform_async(token) if click_striker.counter <= 0
      decrypted_message
    end
  end
end
