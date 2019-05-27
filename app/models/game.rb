class Game < ApplicationRecord
  validates_presence_of :name, :bgg_id

  scope :with_name, ->(name) { where(name: name) }
end
