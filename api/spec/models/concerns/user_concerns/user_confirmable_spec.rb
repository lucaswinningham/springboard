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
        expect { user.trigger_confirmation }.to change { user.confirmation_token }.to be_truthy
      end

      it 'should populate confirmation_digest' do
        expect { user.trigger_confirmation }.to change { user.confirmation_digest }.to be_truthy
      end

      # it 'should populate confirmation_digest with hash of #confirmation_token' do
      #   user.trigger_confirmation

      #   hashed_token = BCrypt::Password.create user.confirmation_token
      #   is_password = BCrypt::Password.new(user.confirmation_digest).is_password? hashed_token

      #   expect(is_password).to be true
      # end

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
