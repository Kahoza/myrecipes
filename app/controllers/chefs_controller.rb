class ChefsController < ApplicationController

  before_action :set_chef, only: [:show, :edit, :update, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]

  def index
    @chefs = Chef.paginate(page: params[:page], per_page: 6)
  end

  def new
    @chef = Chef.new
  end

  def create
    @chef = Chef.new(chef_params)
    if @chef.save
      # The user will be logged in as soon as signed up
      session[:chef_id] = @chef.id
      flash[:success] = "Welcome #{@chef.chefname} to Myrecipes"
      redirect_to chef_path(@chef)
    else
      render 'new'
    end
  end

  def show
    # To add pagination in the show page
    @chef_recipes = @chef.recipes.paginate(page: params[:page], per_page: 6)
  end

  def edit
  end

  def update
    if @chef.update(chef_params)
      flash[:success] = "Your details were successfully updated"
      redirect_to @chef
    else
      render 'edit'
    end
  end

  def destroy
    if !@chef.admin?
    @chef.destroy
    flash[:danger] = "Chef and all associated recipes have been deleted"
    redirect_to chefs_path
    end
  end

  private

  def chef_params
    params.require(:chef).permit(:chefname, :email, :password, :password_confirmation)
  end

  def set_chef
    @chef = Chef.find(params[:id])
  end

  def require_same_user
    if current_chef != @chef and !current_chef.admin?
      flash[:danger] = "You can only edit or edit your own recipes"
      redirect_to chefs_path
    end
  end

  def require_admin
    if logged_in? && !current_chef.admin?
      flash[:danger] = "Only admin users can perform that action"
      redirect_to root_path
    end
  end

end
