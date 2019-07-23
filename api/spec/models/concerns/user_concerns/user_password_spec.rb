RSpec.describe User, type: :model do
  describe 'salt' do
    context 'on create' do
      it 'should populate salt' do
        user = create :user, salt: nil
        valid_salt = BCrypt::Engine.valid_salt? user.salt
        expect(valid_salt).to be true
      end
    end

    context 'on save' do
      it 'should not change salt' do
        user = create :user
        expect { user.update salt: 'bogus' }.to_not change { user.reload.salt }.itself
      end
    end
  end
end
