# app/models/user.rb
class User < ApplicationRecord
  belongs_to :country, optional: true

  has_many :trips, dependent: :destroy
  has_many :posts, dependent: :destroy

  # Travel buddies: viajes de otros donde participo
  has_many :travel_buddies, dependent: :destroy
  has_many :buddy_trips, through: :travel_buddies, source: :trip

  # Photo tagging
  has_many :tags, dependent: :destroy
  has_many :tagged_pictures, through: :tags, source: :picture

  has_one_attached :photo

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include Devise::JWT::RevocationStrategies::JTIMatcher

  belongs_to :country, optional: true

  devise :database_authenticatable,
         :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_cookie_authenticatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: self   # <— OJO: self, no el módulo

  before_create :ensure_jti

  private
  def ensure_jti
    self.jti ||= SecureRandom.uuid
  end
end
