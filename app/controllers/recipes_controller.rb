class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy, :like]
  before_action :require_user_like, only: [:like]
  before_action :require_user, except: [:index, :show, :like]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
     @recipes = Recipe.paginate(page: params[:page], per_page: 6)

  end

  def show
    @comment = Comment.new
    @comments = @recipe.comments.paginate(page: params[:page], per_page: 6)
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    # To be changed once chefs are added to the project
    # For now, the recipes will be assigned to the first chef created
    @recipe.chef = current_chef
    if @recipe.save
      flash[:success] = "Recipe was successfully created!"
      redirect_to recipe_path(@recipe)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @recipe.update(recipe_params)
      flash[:success] = "Recipe wa successfully updated"
      redirect_to recipe_path(@recipe)
    else
      render 'edit'
    end
  end

  def destroy
    Recipe.find(params[:id]).destroy
    flash[:success] = "Recipe successfully deleted"
    redirect_to recipes_path
  end

  def like
    like = Like.create(like: params[:like], chef: current_chef, recipe: @recipe)
  if like.valid?
    flash[:success] = "Your selection was succesful"
    redirect_back(fallback_location: root_path)
  else
    flash[:danger] = "You can only like/dislike a recipe once"
    redirect_back(fallback_location: root_path)
  end
end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :description, ingredient_ids: [])
  end

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def require_same_user
    if current_chef != @recipe.chef and !current_chef.admin?
      flash[:danger] = "You can only edit or edit your own recipes"
      redirect_to recipes_path
    end
  end

  def require_user_like
    if !logged_in?
      flash[:danger] = "You must be logged in to perform that action"
      redirect_back(fallback_location: root_path)
    end
  end

