RSpec.describe User, type: :model do
  blank_values = ['', ' ', "\n", "\r", "\t", "\f"]

  describe 'name' do
    it { should validate_presence_of(:name) }
    it { should_not allow_values(*blank_values).for(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(20) }

    it do
      should_not allow_values(
        'username!',
        'username?',
        'username*',
        'username#',
        'user name'
      ).for(:name)
    end

    it do
      should allow_values(
        'username',
        'user-name',
        'user_name',
        'user1name',
        '_username_',
        '-username-',
        '1username1',
        'USERNAME'
      ).for(:name)
    end
  end

  describe 'email' do
    it { should validate_presence_of(:email) }
    it { should_not allow_values(*blank_values).for(:email) }
    it { should validate_uniqueness_of(:email) }

    it do
      should_not allow_values(
        'plainaddress',
        '#@%^%#$@#$@#.com',
        '@domain.com',
        'Joe Smith <email@domain.com>',
        'email.domain.com',
        'email@domain@domain.com',
        'あいうえお@domain.com',
        'email@domain.com (Joe Smith)',
        'email@-domain.com',
        'email@domain..com'
      ).for(:email)
    end

    it do
      should allow_values(
        'email@domain.com',
        'firstname.lastname@domain.com',
        'email@subdomain.domain.com',
        'firstname+lastname@domain.com',
        'email@123.123.123.123',
        '1234567890@domain.com',
        'email@domain-one.com',
        '_______@domain.com',
        'email@domain.name',
        'email@domain.co.jp',
        'firstname-lastname@domain.com'
      ).for(:email)
    end
  end
end
