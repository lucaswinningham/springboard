module Mutations
  module Users
    RSpec.describe UserSignup, type: :request do
      describe '.resolve' do
        context 'with valid params' do
          let(:new_user) { build :user }

          let(:valid_request) do
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

            new_user = User.last # is this kosher?

            expect(data.userSignup.salt).to eq new_user.salt
            expect(data.userSignup.nonce).to eq new_user.nonce
            expect(data.userSignup.ckey).to eq new_user.ckey
            expect(data.userSignup.civ).to eq new_user.civ
          end
        end

        context 'with invalid name' do
          let(:new_user) { build :user, name: '', email: '' }

          let(:invalid_request) do
            params = { query: query(name: new_user.name, email: new_user.email) }
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
