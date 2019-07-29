module Mutations
  module Users
    RSpec.describe UserSignup, type: :request do
      describe '.resolve' do
        let(:request) do
          params = { query: query(name: new_user.name, email: new_user.email) }
          post '/graphql', params: params
        end

        context 'with valid params' do
          let(:new_user) { build :user }

          it 'creates user' do
            expect { request }.to change { User.count }.by(1)
          end

          it 'returns auth for the new user' do
            request
            auth = data.userSignup
            user = User.find_by_email new_user.email

            expect(auth.salt).to eq user.salt
            expect(auth.nonce).to eq user.nonce
            expect(auth.ckey).to eq user.ckey
            expect(auth.civ).to eq user.civ
          end
        end

        context 'with invalid params' do
          let(:new_user) { build :user, name: '', email: '' }

          it 'returns informative errors' do
            request

            # expect(error_messages.count).to be > 1 # this test belongs on a base_mutation_spec
            expect(error_messages).to include match Regexp.new 'name', Regexp::IGNORECASE
            expect(error_messages).to include match Regexp.new 'email', Regexp::IGNORECASE
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
