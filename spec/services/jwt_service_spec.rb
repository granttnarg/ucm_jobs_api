require 'rails_helper'

RSpec.describe JwtService do
  describe '.encode' do
    it 'encodes a payload into a JWT token' do
      payload = { user_id: 1 }
      token = JwtService.encode(payload)

      expect(token).to be_a(String)
      expect(token.split('.').length).to eq(3)
    end

    it 'adds expiration to the payload' do
      payload = { user_id: 1 }
      token = JwtService.encode(payload)
      decoded_payload = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]

      expect(decoded_payload).to include('exp')
      expect(decoded_payload['exp']).to be_a(Integer)
    end

    it 'allows custom expiration time' do
      payload = { user_id: 1 }
      custom_exp = 2.hours.from_now.to_i
      token = JwtService.encode(payload, custom_exp)
      decoded_payload = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]

      expect(decoded_payload['exp']).to eq(custom_exp)
    end
  end

  describe '.decode' do
    it 'decodes a valid token' do
      original_payload = { user_id: 1 }
      token = JwtService.encode(original_payload)
      decoded_payload = JwtService.decode(token)

      expect(decoded_payload[:user_id]).to eq(original_payload[:user_id])
    end

    it 'returns nil for an invalid token' do
      allow(Rails.logger).to receive(:error)
      invalid_token = 'invalid.token.here'

      expect(JwtService.decode(invalid_token)).to be_nil
    end

    it 'logs an error for invalid tokens' do
      expect(Rails.logger).to receive(:error).with(/JWT decode error/)

      JwtService.decode('invalid.token')
    end
  end
end
