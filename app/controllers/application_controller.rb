class ApplicationController < ActionController::Base

  respond_to :json
  before_action :process_token, unless: :devise_controller?
  skip_before_action :verify_authenticity_token


  private 
    
  # @return []
  def authenticate_user!
    render_401 unless signed_in?
  end

  # @return [TrueClass, FalseClass]
  def signed_in?
    @current_user_id.present?
  end

  # @return [User]
  def current_user
    @current_user ||= User.find_by!(id: @current_user_id, status: 'active')
  end
  

  def process_token
    @token = request.headers['Authorization']
    if @token.present?
      jwt_payload = Jwt::DecodeToken.new.call(@token)
      return render_401 if jwt_payload.nil?

      unless check_if_revoked(jwt_payload['jti'])
        @current_user_id = jwt_payload['id']
        @current_user = User.find_by(id: @current_user_id)
        if @current_user.nil?
          return render_errors([I18n.t('devise.failure.locked')], 'unprocessable_entity')
        end
      end

    else
      render_401
    end
  end

  # @return [TrueClass, FalseClass]
  def check_if_revoked(jti)
    return true if jti.nil?

    !JwtDenylist.select(:jti).find_by(jti: jti).nil?
  end

  def render_401
    render(status: :unauthorized, json: { errors: ["You don't have permission."] })
  end

  def render_404
    render_errors(['this resource could not be found'], 'not_found')
  end

  def render_errors(errors = [], status = 'unprocessable_entity')
    render(json: { errors: errors, success: false }, status: status.to_sym)
  end
end
