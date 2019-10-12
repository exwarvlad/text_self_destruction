class ClickStriker < ActiveRecord::Base
  validates :slug, presence: true
end
