class Location < ApplicationRecord
  belongs_to :country

  has_many :trip_locations, dependent: :destroy, inverse_of: :location
  has_many :trips, through: :trip_locations
  has_many :posts, dependent: :nullify

  has_one_attached :photo

  validates :name, presence: true
end