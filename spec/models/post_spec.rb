require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should validate_presence_of :user_id }
  it { should validate_length_of(:description).is_at_most(314) }

  it { should belong_to(:user) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:likes).dependent(:destroy) }

  describe 'default scope' do
    let!(:user) { create(:user) }
    let!(:post_one) { user.posts.create! }
    let!(:post_two) { user.posts.create! }

    it 'orders descending by date' do
      expect(Post.all).to eq [post_two, post_one]
    end
  end
end
