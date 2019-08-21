require 'support/graphql/respondable'
require 'support/client_mocks/user_password_mock'

require 'examples/graphql/graph_meta/mixins/resolvable_example'

module Mutations
  module Users
    RSpec.describe UserPasswordChange, type: :request do
      include Support::GraphQL::Respondable

      it_behaves_like 'resolvable'

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

      context 'with valid params' do
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
          let(:old_password_message) { nil }
          let(:new_password_message) do
            Support::ClientMocks::UserPasswordMock.pack_password_message(
              user: user, password: 'new_password'
            )
          end

          include_examples 'password change'
          include_examples 'response data'
        end

        context 'with previously set password (user initiated password change)' do
          let(:password) { 'plain_password' }

          before do
            user.update password: Support::ClientMocks::UserPasswordMock.hash_password(
              user: user, password: password
            )
          end

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

          include_examples 'password change'
          include_examples 'response data'
        end
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
