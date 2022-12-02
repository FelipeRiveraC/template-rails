# frozen_string_literal: true

module Api
  class TestController < Api::BaseController

    before_action :authenticate_user!, except: [:index]
    skip_before_action :process_token, only: [:index]
    
    # Not Authorized
    # GET /api/internal/test
    def index
        
        render(json: {
          success: true,
          errors: [],
          data: "Hello World!"
        })
    end

    # Authorized
    # GET /api/internal/test/authorized
    def authorized
        
      render(json: {
        success: true,
        errors: [],
        data: UserSerializer.new(@current_user).serializable_hash[:data]
      })
    end

  end
end
