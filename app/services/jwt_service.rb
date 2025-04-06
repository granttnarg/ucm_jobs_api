class JwtService
  SECRET_KEY = Rails.application.credentials.dig(Rails.env.to_sym, :jwt_secret) || Rails.application.credentials.secret_key_base
  JWT_EXPIRY_DEFAULT = Rails.application.config.x.jwt_expiry_default.to_i.hours.from_now

  def self.encode(payload, exp = JWT_EXPIRY_DEFAULT)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  rescue JWT::DecodeError => e
    Rails.logger.error("JWT decode error: #{e.message}")
    nil
  end
end
