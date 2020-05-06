require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @user = users(:test)
    @post = @user.posts.build(description: 'Hello test')
  end

  test 'should be valid' do
    assert @post.valid?
  end

  test 'user id should be present' do
    @post.user_id = nil
    assert_not @post.valid?
  end

  test 'description not mandatory' do
    @post.description = '   '
    assert @post.valid?
  end

  test 'description should be at most 314 characters' do
    @post.description = 'x' * 315
    assert_not @post.valid?
  end

  test 'order should be descending by creation date' do
    assert_equal posts(:newest), Post.first
  end
end
