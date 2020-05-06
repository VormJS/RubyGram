require 'test_helper'

class PostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test)
  end

  test 'post interface' do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    # Correct pagination link
    assert_select 'a[href=?]', '/?page=2'
    # Post without description
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { description: '' } }
    end
    assert_select 'div#error_explanation', count: 0
    # Valid submission
    description = 'Some nice and funny text here!'
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { description: description } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match description, response.body
    # Delete post
    assert_select 'a', text: 'delete'
    first_post = @user.posts.paginate(page: 1).first
    assert_difference 'Post.count', -1 do
      delete post_path(first_post)
    end
    # Visit different user (no delete links)
    get user_path(users(:test2))
    assert_select 'a', text: 'delete', count: 0
  end

  test 'post sidebar count' do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.posts.length} posts", response.body
    # User with zero posts
    other_user = users(:test4)
    log_in_as(other_user)
    get root_path
    assert_match '0 posts', response.body
    other_user.posts.create!(description: 'A post')
    get root_path
    assert_match '1 post', response.body
  end
end
