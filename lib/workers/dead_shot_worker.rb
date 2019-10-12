require 'byebug'

class DeadShotWorker
  include Sidekiq::Worker

  def perform(token)
    click_striker = ClickStriker.find_by_slug(token)
    return if click_striker.nil?

    click_striker.destroy
    REDIS.del(token)
  end
end