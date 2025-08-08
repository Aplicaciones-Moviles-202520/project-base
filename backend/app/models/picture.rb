# app/models/picture.rb
class Picture < ApplicationRecord
  belongs_to :post
  has_many :tags, dependent: :destroy

  has_one_attached :file
end
