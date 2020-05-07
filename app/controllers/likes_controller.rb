class LikesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :like_owner, only: :destroy
  before_action :find_post

  def create
    if already_liked?
      flash[:notice] = "You can't like more than once"
    else
      @post.likes.create(user_id: current_user.id)
    end
    redirect_to request.referrer || root_url
  end

  def destroy
    if !already_liked?
      flash[:notice] = 'Cannot unlike'
    else
      @post.likes.find_by(user_id: current_user.id).destroy
    end
    redirect_to request.referrer || root_url
  end

  private

    def find_post
      @post = Post.find(params[:post_id])
    end

    def like_owner
      @comment = current_user.likes.find_by(id: params[:id])
    end

    def already_liked?
      Like.where(user_id: current_user.id, post_id:
      params[:post_id]).exists?
    end
end
