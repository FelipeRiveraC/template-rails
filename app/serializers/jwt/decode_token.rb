# frozen_string_literal: true
module Jwt
  class DecodeToken

    include ParseJwt

    # @return [String, NilClass]
    # @param [String] token
    def call(token)
      raise('Invalid token') if token.blank?

      JWT.decode(parse(token), Rails.application.credentials.secret_key_base).first
    rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError => e
      Rails.logger.debug("Error token: #{e}")
      return nil
    end

  end
end
