require 'support/graphql/respondable'

module Mutations
  module Users
    RSpec.describe UserCreate, type: :request do
      include Support::GraphQL::Respondable

      let(:request) do
        params = { query: query(name: new_user.name, email: new_user.email) }
        post '/graphql', params: params
      end

      context 'with valid new user params' do
        let(:new_user) { build :user }

        it 'should create user' do
          expect { request }.to change { User.count }.by(1)
        end

        it 'should refresh user auth' do
          user_instance = new_user
          expect(User).to receive(:new) { user_instance }
          expect(user_instance).to receive(:refresh_auth)

          request
        end

        it 'should return user auth' do
          request
          user = User.find_by email: new_user.email

          expect(data).to be_truthy
          expect(data.userCreate).to be_truthy
          expect(data.userCreate.salt).to eq user.salt
          expect(data.userCreate.nonce).to eq user.nonce
          expect(data.userCreate.ckey).to eq user.ckey
          expect(data.userCreate.civ).to eq user.civ
        end

        it 'should trigger user confirmation' do
          user_instance = new_user
          expect(User).to receive(:new) { user_instance }
          expect(user_instance).to receive(:trigger_confirmation)

          request
        end
      end

      context 'with invalid new user params' do
        let(:new_user) { build :user, name: '', email: '' }

        it 'should return validation errors' do
          request
          expect(error_messages).to eq new_user.tap(&:validate).errors.full_messages
        end
      end

      context 'with existing user params' do
        let(:existing_user) { create :user }
        let(:new_user) { build :user, name: existing_user.name, email: existing_user.email }

        it 'should return validation errors' do
          request
          expect(error_messages).to eq new_user.tap(&:validate).errors.full_messages
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
