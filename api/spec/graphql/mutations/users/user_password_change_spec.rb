require 'support/graphql/respondable'
require 'support/client_mocks/user_password_mock'

module Mutations
  module Users
    RSpec.describe UserPasswordChange, type: :request do
      include Support::GraphQL::Respondable

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
              Support::ClientMocks::UserPasswordMock.pack_password_message(
                user: user, password: 'new_password'
              )
            end

            it 'changes user password_digest' do
              expect { request }.to change { user.reload.password_digest }.itself
            end

            it 'should #refresh_jwt for user' do
              user_instance = user
              expect(User).to receive(:find_by) { user_instance }
              expect(user_instance).to receive(:refresh_jwt)

              request
            end

            it 'returns jwt for user' do
              Timecop.freeze do
                request
                expected_jwt = user.refresh_jwt

                expect(data).to be_truthy
                expect(data.userPasswordChange).to be_truthy
                expect(data.userPasswordChange.jwt).to eq expected_jwt
              end
            end
          end
        end

        context 'with previously set password' do
          let(:password) { 'plain_password' }
          let(:hashed) do
            Support::ClientMocks::UserPasswordMock.hash_password user: user, password: password
          end

          before { user.update password: hashed }

          context 'with valid params' do
            let(:old_password_message) do
              Support::ClientMocks::UserPasswordMock.pack_password_message(
                user: user, password: password
              )
            end

            let(:new_password_message) do
              Support::ClientMocks::UserPasswordMock.pack_password_message(
                user: user, password: 'new_password'
              )
            end

            it 'changes user password_digest' do
              expect { request }.to change { user.reload.password_digest }.itself
            end

            it 'should #refresh_jwt for user' do
              user_instance = user
              expect(User).to receive(:find_by) { user_instance }
              expect(user_instance).to receive(:refresh_jwt)

              request
            end

            it 'returns jwt for user' do
              Timecop.freeze do
                request
                expected_jwt = user.refresh_jwt

                expect(data).to be_truthy
                expect(data.userPasswordChange).to be_truthy
                expect(data.userPasswordChange.jwt).to eq expected_jwt
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
              jwt
            }
          }
        GQL
      end
    end
  end
end
