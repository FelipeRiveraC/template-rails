class JwtDenylist < ApplicationRecord

  self.table_name = 'jwt_denylist'

  def self.revoke_token!(jti)
    JwtDenylist.create!(jti: jti)
  end

end