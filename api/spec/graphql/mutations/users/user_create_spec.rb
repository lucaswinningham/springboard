require 'support/graphql/respondable'

require 'examples/graphql/graph_meta/mixins/resolvable_example'

module Mutations
  module Users
    RSpec.describe UserCreate, type: :request do
      include Support::GraphQL::Respondable

      it_behaves_like 'resolvable'

      let(:request) do
        params = { query: query(name: new_user.name, email: new_user.email) }
        post '/graphql', params: params
      end

      let(:identifying_params) { new_user.attributes.slice 'name', 'email' }

      context 'with valid params' do
        let(:new_user) { build :user }

        it 'should create user' do
          expect { request }.to change { User.find_by identifying_params }.from(nil).to(be_truthy)
        end

        # describe 'user auth refresh' do
        #   it 'should refresh user nonce' do
        #     expect(user.nonce).to be_truthy
        #   end

        #   it 'should refresh user ckey' do
        #     expect(user.ckey).to be_truthy
        #   end

        #   it 'should refresh user civ' do
        #     expect(user.civ).to be_truthy
        #   end

        #   it 'should refresh user auth_expires_at' do
        #     expect(user.auth_expires_at).to be_truthy
        #   end
        # end

        # describe 'user confirmation' do
        #   it 'should get triggered' do
        #     expect { request }.to change { User.find_by identifying_params }.from(nil)
        #   end
        # end

        # it 'should trigger user confirmation' do
        #   expect(user.confirmation_digest).to be_truthy
        # end

        describe 'response data' do
          before { request }
          let(:found_user) { User.find_by identifying_params }

          it 'should return data' do
            expect(data).to be_truthy
          end

          it 'should return userCreate' do
            expect(data.userCreate).to be_truthy
          end

          it 'should return user salt' do
            expect(data.userCreate.salt).to eq found_user.salt
          end

          it 'should return user nonce' do
            expect(data.userCreate.nonce).to eq found_user.nonce
          end

          it 'should return user ckey' do
            expect(data.userCreate.ckey).to eq found_user.ckey
          end

          it 'should return user civ' do
            expect(data.userCreate.civ).to eq found_user.civ
          end
        end
      end

      context 'with taken user name' do
        let(:existing_user) { create :user }
        let(:new_user) { build :user, name: existing_user.name }

        it 'should not create user' do
          expect { request }.to_not(
            change { User.find_by name: existing_user.name }.from(existing_user)
          )
        end

        it 'should return error' do
          request
          expect(error_messages).to include 'Name has already been taken'
        end
      end

      context 'with invalid user name' do
        let(:new_user) { build :user, name: 'user name' }

        it 'should not create user' do
          expect { request }.to_not(
            change { User.find_by name: new_user.name }.from(nil)
          )
        end

        it 'should return error' do
          request
          expect(error_messages).to include 'Name is invalid'
        end
      end

      context 'with taken user email' do
        let(:existing_user) { create :user }
        let(:new_user) { build :user, email: existing_user.email }

        it 'should not create user' do
          expect { request }.to_not(
            change { User.find_by email: existing_user.email }.from(existing_user)
          )
        end

        it 'should return error' do
          request
          expect(error_messages).to include 'Email has already been taken'
        end
      end

      context 'with invalid user email' do
        let(:new_user) { build :user, email: 'email@domain@domain.com' }

        it 'should not create user' do
          expect { request }.to_not(
            change { User.find_by email: new_user.email }.from(nil)
          )
        end

        it 'should return error' do
          request
          expect(error_messages).to include 'Email is invalid'
        end
      end

      def query(name:, email:)
        <<~GQL
          mutation {
            userCreate(name: \"#{name}\" email: \"#{email}\") {
              salt nonce ckey civ
            }
          }
        GQL
      end
    end
  end
end
