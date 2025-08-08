# app/models/user.rb
class User < ApplicationRecord
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
