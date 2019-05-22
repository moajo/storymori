class Story < ApplicationRecord
  has_many :pages

  validates :title, presence: true
  validates :summary, presence: true
end
