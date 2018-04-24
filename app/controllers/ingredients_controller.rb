class IngredientsController < ApplicationController

  def index
    @ingredients = Ingredient.paginate(page: params[:page], per_page: 6)
  end

  def show
  end

  def new
  end

  def create
  end

end
