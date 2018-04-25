class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [:edit, :update, :show]

  def index
    @ingredients = Ingredient.paginate(page: params[:page], per_page: 6)
  end

  def show
    @ingredient_recipes = @ingredient.recipes.paginate(page: params[:page], per_page: 6)
  end

  def new
  end

  def create
  end

  def update
  end

  private

  def set_ingredient
    @ingredient = Ingredient.find(params[:id])
  end

end
