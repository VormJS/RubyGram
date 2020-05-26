require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :name }
  it { should validate_length_of(:name).is_at_most(50) }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
  it { should validate_length_of(:email).is_at_most(255) }
  it { should validate_presence_of(:password) }
  it { should validate_length_of(:password).is_at_least(8) }

  it { should allow_value(false).for(:admin) }
  it { should allow_value(true).for(:admin) }

  it { should have_many(:posts).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:followers) }
  it { should have_many(:following) }

  describe 'valid/invalid emails check' do
    let!(:user) { build(:user) }

    it 'valid emails' do
      valid_addresses = %w[user@example.com
                           USER@foo.COM
                           A_US-ER@foo.bar.org
                           first.last@foo.jp
                           alice+bob@barbaz.cn
                           alice...bob@bar...baz-.cn
                           alicebob@bar-baz.cn]
      valid_addresses.each do |valid_address|
        user.email = valid_address
        expect(user.valid?).to eq true
      end
    end

    it 'invalid emails' do
      invalid_addresses = %w[user@example,com
                             foo@bar+baz.com
                             user_at_foo.org
                             user.name@example.
                             foo@bar_baz..com
                             foo@bar_baz.com.]
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user.valid?).to eq false
      end
    end
  end

  describe 'follows' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    
    it 'user can follow/unfollow' do
      user2.follow(user1)
      expect(user2.following.include?(user1)).to eq true
      expect(user1.followers.include?(user2)).to eq true

      expect(user2.following?(user1)).to eq true

      user2.unfollow(user1)
      expect(user2.following.include?(user1)).to eq false
      expect(user1.followers.include?(user2)).to eq false
    end
  end
end
