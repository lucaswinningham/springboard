describe AuthServices::JwtService do
  let(:user) { create(:user).tap(&:refresh_auth) }

  describe '::to_payload' do
    it 'should have correct payload' do
      Timecop.freeze do
        sub = user.name
        now = Time.now.utc.to_i
        exp = 2.hours.from_now.utc.to_i
        expected_payload = { sub: sub, iat: now, nbf: now, exp: exp }

        payload = AuthServices::JwtService.to_payload user: user
        expect(payload).to eq expected_payload
      end
    end
  end

  describe '::encode' do
    it 'should encode a payload' do
      payload = {
        sub: 'user_name', iat: 1_565_132_572, nbf: 1_565_132_572, exp: 1_565_139_772
      }
      secret = '7d5dbe53b1e2acc1244a04f3433b51e2'
      expected_token = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyX25hbWUiLCJpYXQiOjE1NjUxMzI1NzIsIm5iZiI6MTU2NTEzMjU3MiwiZXhwIjoxNTY1MTM5NzcyfQ.0mjYZkpIv4KFZivfP15jFH9knVYcsNpJrz74-hVHkW0' # rubocop:disable Metrics/LineLength

      token = AuthServices::JwtService.encode payload: payload, secret: secret
      expect(token).to eq expected_token
    end
  end

  describe '::decode' do
    it 'should decode a token' do
      token = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyX25hbWUiLCJpYXQiOjE1NjUxMzMwMjgsIm5iZiI6MTU2NTEzMzAyOCwiZXhwIjoxNTY1MTQwMjI4fQ.KoxXM6w6sn-89I8wll9Ct6q1rYAGvWHwS0meGVsIPFU' # rubocop:disable Metrics/LineLength
      secret = 'de46336697aa2df6b1eea5a2ace32c3a'
      expected_payload = {
        sub: 'user_name', iat: 1_565_133_028, nbf: 1_565_133_028, exp: 1_565_140_228
      }

      payload = AuthServices::JwtService.decode token: token, secret: secret, verify: false
      expect(payload).to eq expected_payload
    end

    context 'given invalid token' do
      it 'should return nil instead of error' do
        secret = 'f0aa38c68f99864b3eb8642beb0de4dd'
        decode_response = AuthServices::JwtService.decode token: '', secret: secret
        expect(decode_response).to be_nil
      end
    end

    context 'given invalid secret' do
      it 'should return nil instead of error' do
        token = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJmcmFua2x5biIsImlhdCI6MTU2NTEzOTQzNCwibmJmIjoxNTY1MTM5NDM0LCJleHAiOjE1NjUxNDY2MzR9.mDtV5VqdMM7GgVIiOfpTLTieym_hRhsmbwFmOaUlyVw' # rubocop:disable Metrics/LineLength
        decode_response = AuthServices::JwtService.decode token: token, secret: ''
        expect(decode_response).to be_nil
      end
    end
  end

  context 'given the same secret' do
    it 'should decode a token into the original payload' do
      original_payload = { some: 'thing' }
      secret = AuthServices::JwtService.random_key

      token = AuthServices::JwtService.encode payload: original_payload, secret: secret
      payload = AuthServices::JwtService.decode token: token, secret: secret

      expect(payload).to eq original_payload
    end
  end

  describe '::random_key' do
    it 'should give a random key' do
      jwt_key = 'jwt_key'
      expect(SecureRandom).to receive(:hex) { jwt_key }
      expect(AuthServices::JwtService.random_key).to be jwt_key
    end
  end
end
