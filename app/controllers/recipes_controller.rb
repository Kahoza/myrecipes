class RecipesController < ApplicationController

  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    # To be changed once chefs are added to the project
    # For now, the recipes will be assigned to the first chef created
    @recipe.chef = Chef.first
    if @recipe.save
      flash[:success] = "Recipe was successfully created!"
      redirect_to recipe_path(@recipe)
    else
      render 'new'
    end
  end

  private
  def recipe_params
    params.require(:recipe).permit(:name, :description)
  end

end
