class Page < ApplicationRecord
  belongs_to :story

  validates :name, presence: true
  validates :text, presence: true
  validates :story_id, presence: true
end
