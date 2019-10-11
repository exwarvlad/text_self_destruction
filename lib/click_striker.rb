class ClickStriker < ActiveRecord::Base
  before_save :remove_namespace
  validates :slug, presence: true

  private

  def remove_namespace
    self.body = body.chomp.chomp('0K') if body.present?
  end
end
