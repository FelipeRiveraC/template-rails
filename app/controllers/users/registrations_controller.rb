module Users
  class RegistrationsController < Devise::RegistrationsController
    skip_before_action :verify_authenticity_token, raise: false

    def create
      user = User.new(sign_up_params)
      if user.save!
        token = user.generate_jwt
        render json: {token: token}, status: 201
      else
        render json: { errors:  user.errors.full_messages }, status: :unprocessable_entity
      end
    end
    def sign_up_params
      params.require(:user).permit(:name, :username, :email, :password, :password_confirmation, :phone, :address, :city, :state, :country, :zip_code)
    end

  end
end