# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController

    skip_before_action :verify_authenticity_token, raise: false
    # POST /users/sign_in
    def create
      user = User.find_by(email: sign_in_params[:email])

      if user.nil?
        return render(json: { errors: ['Usuario no encontrado'], success: false }, status: :unprocessable_entity)
      end


      if user && user.valid_password?(sign_in_params[:password])
        token = user.generate_jwt(sign_in_params[:remember_me])
        exp = sign_in_params[:remember_me] ? 7 : 1
        render(json: { token: token, expires: exp.days.from_now.to_i.to_s , user: { email: user.email }, errors: [], success: true }, status: :ok)
      else
        invalid_login_attempt
      end
    end

    # DELETE /users/sign_out
    def destroy
      ActiveRecord::Base.transaction do
        begin
          @token = request.headers['Authorization']
          jwt_payload = Jwt::DecodeToken.new.call(@token)

          if jwt_payload.nil?
            return render(json: { success: true, errors: [] })
          end

          if !jwt_payload.nil? && !check_if_revoked(jwt_payload['jti'])
            JwtDenylist.revoke_token!(jwt_payload['jti'])
            sign_out
          end
          render(json: { success: true, errors: [] })
        rescue => e
          render(json: { success: true, errors: [e.message] })
        end
      end
    end

    private

    def invalid_login_attempt
      render(json: { errors: ['Email or Password is invalid'] }, status: :unprocessable_entity)
    end

    def sign_in_params
      params.require(:session).permit(%i[
        email
        password
        remember_me
      ])
    end

    def prod_params
      params.permit([
        :token
      ])
    end

  end
end
