module Mutations
  module Users
    RSpec.describe UserPasswordChange, type: :request do
      describe '.resolve' do
        let(:user) { create(:user).tap(&:refresh_auth) }

        let(:request) do
          params = {
            query: query(
              email: user.email,
              old_password_message: old_password_message,
              new_password_message: new_password_message
            )
          }
          post '/graphql', params: params
        end

        context 'without previously set password (on user create)' do
          context 'with valid params' do
            let(:old_password_message) { nil }
            let(:new_password_message) do
              ClientMocks::UserPasswordMock.pack_password_message(
                user: user, password: 'new_password'
              )
            end

            it 'changes user password_digest' do
              expect { request }.to change { user.reload.password_digest }.itself
            end

            it 'should #refresh_token for user' do
              user_instance = user
              expect(User).to receive(:find_by) { user_instance }
              expect(user_instance).to receive(:refresh_token)

              request
            end

            it 'returns token for user' do
              Timecop.freeze do
                request
                expected_token = user.refresh_token

                token = data.userPasswordChange.token
                expect(token).to eq expected_token
              end
            end
          end
        end

        context 'with previously set password' do
          let(:password) { 'plain_password' }
          let(:hashed) { ClientMocks::UserPasswordMock.hash_password user: user, password: password }

          before { user.update password: hashed }

          context 'with valid params' do
            let(:old_password_message) do
              ClientMocks::UserPasswordMock.pack_password_message(
                user: user, password: password
              )
            end

            let(:new_password_message) do
              ClientMocks::UserPasswordMock.pack_password_message(
                user: user, password: 'new_password'
              )
            end

            it 'changes user password_digest' do
              expect { request }.to change { user.reload.password_digest }.itself
            end

            it 'should #refresh_token for user' do
              user_instance = user
              expect(User).to receive(:find_by) { user_instance }
              expect(user_instance).to receive(:refresh_token)

              request
            end

            it 'returns token for user' do
              Timecop.freeze do
                request
                expected_token = user.refresh_token

                token = data.userPasswordChange.token
                expect(token).to eq expected_token
              end
            end
          end
        end

        # context 'with invalid params' do
        #   let(:new_user) { build :user, name: '', email: '' }

        #   it 'returns informative errors' do
        #     request

        #     # expect(error_messages.count).to be > 1 # this test belongs on a base_mutation_spec
        #     expect(error_messages).to include match Regexp.new 'name', Regexp::IGNORECASE
        #     expect(error_messages).to include match Regexp.new 'email', Regexp::IGNORECASE
        #   end
        # end
      end

      def query(email:, old_password_message:, new_password_message:)
        <<~GQL
          mutation {
            userPasswordChange(
              email: \"#{email}\"
              oldPasswordMessage: \"#{old_password_message}\"
              newPasswordMessage: \"#{new_password_message}\"
            ) {
              token
            }
          }
        GQL
      end
    end
  end
end
