class Post < ApplicationRecord
  belongs_to :user
  belongs_to :trip
  belongs_to :location

  has_many :pictures, dependent: :destroy
  has_many :videos,   dependent: :destroy
  has_many :audios,   dependent: :destroy

  validates :body, length: { maximum: 5000 }, allow_blank: true
end
