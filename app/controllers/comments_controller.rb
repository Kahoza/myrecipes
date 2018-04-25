class CommentsController < ApplicationController
  before_action :require_user

  def create
    @recipe = Recipe.find(params[:recipe_id])
    @comment = @recipe.comments.build(comment_params)
    @comment.chef = current_chef
    if @comment.save
      ActionCable.server.broadcast "comments", render(partial: 'comments/comment', object: @comment)
      # flash[:success] = "Your comment was successfully created"
      # redirect_to recipe_path(@recipe)
    else
      flash[:danger] = "Your comment wasn't saved"
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:description)
  end
end
