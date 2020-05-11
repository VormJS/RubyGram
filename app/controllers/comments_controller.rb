class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :comment_owner, only: :destroy

  def create
    @comment = Comment.create(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:success] = 'Comment created!'
    else
      flash[:danger] = 'Comment creation failed'
    end
    redirect_to request.referrer || root_url
  end

  def destroy
    @comment.destroy
    flash[:success] = 'Comment deleted'
    redirect_to request.referrer || root_url
  end

  private

    def comment_params
      params.require(:comment).permit(:text, :post_id)
    end

    def comment_owner
      @comment = current_user.comments.find_by(id: params[:id])
    end
end
