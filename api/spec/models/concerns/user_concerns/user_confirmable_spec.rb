RSpec.describe User, type: :model do
  describe '#confirm' do
    let(:user) { create :user }

    it 'should populate confirmed_at' do
      Timecop.freeze do
        expect { user.confirm }.to change { user.confirmed_at }.to Time.now.utc
      end
    end
  end

  describe '#trigger_confirmation' do
    context 'when unconfirmed' do
      let(:user) { create :user, confirmation_digest: nil, confirmed_at: nil }

      it 'should set #confirmation_token' do
        new_token = 'new_confirmation_token'

        expect(SecureRandom).to receive(:hex) { new_token }
        expect { user.trigger_confirmation }.to change { user.confirmation_token }.to new_token
      end

      it 'should populate confirmation_digest with hash of #confirmation_token' do
        new_token = 'new_confirmation_token'
        new_digest = 'new_confirmation_digest'

        expect(SecureRandom).to receive(:hex) { new_token }
        expect(BCrypt::Password).to receive(:create).with(new_token) { new_digest }
        expect { user.trigger_confirmation }.to change { user.confirmation_digest }.to new_digest
      end

      it 'should send confirmation mail' do
        mailer = Mailers::UserMailers::ConfirmationMailer.new(user)

        expect(Mailers::UserMailers::ConfirmationMailer).to receive(:new).with(user) { mailer }
        expect(mailer).to receive(:deliver)

        user.trigger_confirmation
      end
    end

    context 'when confirmed' do
      let(:user) { create(:user).tap(&:confirm) }

      it 'should not change #confirmation_token' do
        expect { user.trigger_confirmation }.not_to change { user.confirmation_token }.itself
      end

      it 'should not change confirmation_digest' do
        expect { user.trigger_confirmation }.not_to change { user.confirmation_digest }.itself
      end

      it 'should not send confirmation mail' do
        expect(Mailers::UserMailers::ConfirmationMailer).not_to receive(:new)

        user.trigger_confirmation
      end
    end
  end
end
