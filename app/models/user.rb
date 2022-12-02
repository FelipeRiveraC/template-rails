class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Returns a JWT token for the user
  def generate_jwt(exp = false)
    exp = exp ? 7 : 1
    JWT.encode({ id: id, exp: exp.days.from_now.to_i, jti: SecureRandom.uuid }, Rails.application.credentials.secret_key_base)
  end
  
end
