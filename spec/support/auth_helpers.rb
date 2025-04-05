module AuthHelpers
  def generate_token_for(user)
    JwtService.encode({ user_id: user.id })
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
end
