# app/models/user.rb
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

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
