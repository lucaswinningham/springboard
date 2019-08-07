describe AuthServices::CipherService do
  describe '::encrypt' do
    it 'should encrypt and encode a message' do
      key = "ZQ6UaBUEN8CePN4V0162fQ==\n"
      iv = "uu5Q2rZtbIwuAX+h4SYEXA==\n"
      expected_encrypted = "f0MnHuT4Xc33drJ4alMVcg==\n"

      encrypted = AuthServices::CipherService.encrypt message: 'test message', key: key, iv: iv
      expect(encrypted).to eq expected_encrypted
    end
  end

  describe '::decrypt' do
    it 'should decode and decrypt a message' do
      key = "O3GhpukThHID3LlFv8Y3Cw==\n"
      iv = "/i0uDJ8Y2NFmCcDriCSwmA==\n"
      encrypted = "UArfsxdVvB+etXp/JrVSuw==\n"
      expected_decrypted = 'test message'

      decrypted = AuthServices::CipherService.decrypt message: encrypted, key: key, iv: iv
      expect(decrypted).to eq expected_decrypted
    end
  end

  context 'given the same cipher key and iv' do
    it 'should decrypt an encrypted message into the original plain test' do
      key = AuthServices::CipherService.random_key
      iv = AuthServices::CipherService.random_iv
      plain_text = 'test message'

      encrypted = AuthServices::CipherService.encrypt message: plain_text, key: key, iv: iv
      decrypted = AuthServices::CipherService.decrypt message: encrypted, key: key, iv: iv

      expect(decrypted).to eq plain_text
    end
  end

  describe '::random_key' do
    it 'should give a random cipher key' do
      regexp = AuthServices::CipherService::VALID_KEY_REGEXP
      expect(AuthServices::CipherService.random_key).to match regexp
    end
  end

  describe '::random_iv' do
    it 'should give a random cipher iv' do
      regexp = AuthServices::CipherService::VALID_IV_REGEXP
      expect(AuthServices::CipherService.random_iv).to match regexp
    end
  end
end
