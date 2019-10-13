require 'byebug'

class DeadShotWorker
  include Sidekiq::Worker

  def perform(token)
    click_striker = ClickStriker.find_by_slug(token)
    return if click_striker.nil?

    remove_old_dead_shot_order(click_striker.jid)

    click_striker.destroy
    REDIS.del(token)
  end

  private

  def remove_old_dead_shot_order(jid)
    return if jid.nil?

    ss = Sidekiq::ScheduledSet.new
    ss.each { |job| job.delete if job.jid == jid }
  end
end
