module Mutations
  module Users
    RSpec.describe UserSignup, type: :request do
      describe '.resolve' do
        context 'with valid params' do
          let(:valid_request) do
            new_user = build :user
            params = { query: query(name: new_user.name, email: new_user.email) }
            post '/graphql', params: params
          end

          it 'creates user' do
            expect { valid_request }.to change { User.count }.by(1)
          end

          it 'returns user auth' do
            valid_request

            expect(data).to be_present
            expect(data.userSignup).to be_present

            expect(data.userSignup.salt).to be_present
            expect(data.userSignup.nonce).to be_present
            expect(data.userSignup.ckey).to be_present
            expect(data.userSignup.civ).to be_present
          end
        end

        context 'with invalid name' do
          let(:invalid_request) do
            invalid_new_user = build :user, name: ''
            params = { query: query(name: invalid_new_user.name, email: invalid_new_user.email) }
            post '/graphql', params: params
          end

          it 'returns error' do
            invalid_request
            expect(errors).to be_present
          end
        end
      end

      def query(name:, email:)
        <<~GQL
          mutation {
            userSignup(
              name: \"#{name}\"
              email: \"#{email}\"
            ) {
              salt
              nonce
              ckey
              civ
            }
          }
        GQL
      end
    end
  end
end
