require_relative '../../lib/mutators/token_mutator'

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
      BodyMutator.decipher_message(REDIS.get(token))
      # todo
      # cleans pg and redis message
    end
  end
end
