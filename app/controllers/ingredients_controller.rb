class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [:edit, :update, :show]
  before_action :require_admin, except: [:show, :index]

  def index
    @ingredients = Ingredient.paginate(page: params[:page], per_page: 6)
  end

  def show
    @ingredient_recipes = @ingredient.recipes.paginate(page: params[:page], per_page: 6)
  end

  def new
    @ingredient = Ingredient.new
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)
    if @ingredient.save
      flash[:success] = "Ingredient was successfully created"
      redirect_to ingredient_path(@ingredient)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @ingredient.update(ingredient_params)
      flash[:success] = "Ingredient name was successfully updated"
      redirect_to @ingredient
    else
      reder 'edit'
    end
  end

  private

  def set_ingredient
    @ingredient = Ingredient.find(params[:id])
  end

  def ingredient_params
    params.require(:ingredient).permit(:name)
  end

  def require_admin
    if !logged_in? || (logged_in? and !current_chef.admin?)
      flash[:danger] = "Only admin users can perform that action"
      redirect_to ingredients_path
    end
  end

end
