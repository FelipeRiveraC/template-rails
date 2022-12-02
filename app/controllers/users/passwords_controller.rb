# frozen_string_literal: true

module Users
  class PasswordsController < Devise::PasswordsController

    # GET /resource/password/new
    # def new
    #   super
    # end

    # POST /resource/password
    def create
      self.resource = resource_class.send_reset_password_instructions(resource_params)
      yield(resource) if block_given?

      if successfully_sent?(resource)
        render(json: { success: true, errors: [], data: after_sending_reset_password_instructions_path_for(resource_name) })
      else
        render(json: { success: false, errors: resource.errors.full_messages })
      end
    end

    # GET /resource/password/edit?reset_password_token=abcdef
    # def edit
    #   super
    # end

    # PUT /resource/password
    def update
      self.resource = resource_class.reset_password_by_token(resource_params)
      yield(resource) if block_given?

      if resource.errors.empty?
        resource.unlock_access! if unlockable?(resource)
        if Devise.sign_in_after_reset_password
          resource.after_database_authentication
        end
        render(json: { success: true, errors: [] })
      else
        set_minimum_password_length
        render(json: { success: false, errors: resource.errors.full_messages }, status: :unprocessable_entity)
      end
    end

    # protected

    # def after_resetting_password_path_for(resource)
    #   super(resource)
    # end

    # The path used after sending reset password instructions
    # def after_sending_reset_password_instructions_path_for(resource_name)
    #   super(resource_name)
    # end

  end
end
