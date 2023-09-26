require 'support/graphql/respondable'
require 'support/client_mocks/user_password_mock'

require 'examples/graphql/graph_meta/mixins/resolvable_example'

# add test about malformed message

module Mutations
  module Users
    RSpec.describe UserPasswordChange, type: :request do
      include Support::GraphQL::Respondable

      it_behaves_like 'resolvable'

      let(:user) { create(:user).tap(&:refresh_auth) }

      let(:request) do
        params = {
          query: query(
            email: email,
            old_password: old_password,
            new_password: new_password
          )
        }
        post '/graphql', params: params
      end

      def update_user_password(password)
        user.update password: Support::ClientMocks::UserPasswordMock.hash_password(
          user: user, password: password
        )
      end

      def pack_password(password)
        Support::ClientMocks::UserPasswordMock.pack_password_message(
          user: user, password: password
        )
      end

      context 'with valid params' do
        let(:email) { user.email }
        let(:new_password) { pack_password 'new_password' }

        shared_examples 'password change' do
          it 'changes user password_digest' do
            expect { request }.to change { user.reload.password_digest }.itself
          end
        end

        shared_examples 'response data' do
          describe 'response data' do
            before { request }

            it 'should return data' do
              expect(data).to be_truthy
            end

            it 'should return userPasswordChange' do
              expect(data.userPasswordChange).to be_truthy
            end

            it 'should return user jwt' do
              expect(data.userPasswordChange.jwt).to eq user.refresh_jwt
            end
          end
        end

        context 'without previously set password (on user create)' do
          let(:old_password) { nil }

          include_examples 'password change'
          include_examples 'response data'
        end

        context 'with previously set password (user initiated password change)' do
          let(:password) { 'old_password' }
          let(:old_password) { pack_password password }

          before { update_user_password password }

          include_examples 'password change'
          include_examples 'response data'
        end
      end

      context 'with unknown user' do
        let(:email) { build(:user).email }
        let(:old_password) { pack_password 'old_password' }
        let(:new_password) { pack_password 'new_password' }

        it 'should return error' do
          request
          expect(error_messages).to include 'User email not found.'
        end
      end

      context 'with invalid nonce' do
        let(:email) { user.email }
        let(:new_password) { pack_password 'new_password' }

        let(:invalid_nonce) { 'bogus' }

        context 'for old_password' do
          let(:password) { 'old_password' }
          let(:old_password) { pack_password password }

          before { update_user_password password }
          before { user.update nonce: invalid_nonce }

          it 'should return error' do
            request
            expect(error_messages).to include 'Invalid old_password nonce.'
          end
        end

        context 'for new_password' do
          let(:old_password) { nil }

          before { user.update nonce: invalid_nonce }

          it 'should return error' do
            request
            expect(error_messages).to include 'Invalid new_password nonce.'
          end
        end
      end

      context 'with incorrect old_password' do
        let(:password) { 'old_password' }
        let(:email) { user.email }
        let(:old_password) { pack_password 'bogus' }
        let(:new_password) { pack_password 'new_password' }

        before { update_user_password password }

        it 'should return error' do
          request
          expect(error_messages).to include 'Incorrect old_password.'
        end
      end

      def query(email:, old_password:, new_password:)
        <<~GQL
          mutation {
            userPasswordChange(
              email: \"#{email}\"
              oldPassword: \"#{old_password}\"
              newPassword: \"#{new_password}\"
            ) {
              jwt
            }
          }
        GQL
      end
    end
  end
end
