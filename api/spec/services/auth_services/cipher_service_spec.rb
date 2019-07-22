describe AuthServices::CipherService do
  describe '::encrypt' do
    it 'should encrypt and encode a message' do
      key = "ZQ6UaBUEN8CePN4V0162fQ==\n"
      iv = "uu5Q2rZtbIwuAX+h4SYEXA==\n"
      encrypted = AuthServices::CipherService.encrypt message: 'test', key: key, iv: iv
      expect(encrypted).to eq "Q/Sa2X8gDWqJMW1mCd9t1Q==\n"
    end
  end

  describe '::decrypt' do
    it 'should decode and decrypt a message' do
      key = "O3GhpukThHID3LlFv8Y3Cw==\n"
      iv = "/i0uDJ8Y2NFmCcDriCSwmA==\n"
      encrypted = "x6f/tFde5SY8vfsgRL1wew==\n"
      decrypted = AuthServices::CipherService.decrypt message: encrypted, key: key, iv: iv
      expect(decrypted).to eq 'test'
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
      regexp = Regexp.new '^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$'
      expect(AuthServices::CipherService.random_key).to match regexp
    end
  end

  describe '::random_key' do
    it 'should give a random cipher iv' do
      regexp = Regexp.new '^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$'
      expect(AuthServices::CipherService.random_iv).to match regexp
    end
  end
end
