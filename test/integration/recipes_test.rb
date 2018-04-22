require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: "karen", email: "karen@example.com")
    @recipe = Recipe.create(name: "Pancakes", description: "Super easy recipe", chef: @chef)
    # the build method indicates that the current chef is creating the recipe
    @recipe2 = @chef.recipes.build(name: "Tacos", description: "Use corn tortillas")
    @recipe2.save
  end

  test "should get recipes index" do
    get recipes_path
    assert_response :success
  end

  test "should get the list of all recipes" do
    get recipes_path
    assert_template 'recipes/index'
    assert_match @recipe.name, response.body
    assert_match @recipe2.name, response.body
  end
end
