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
    # We want to be able to click on the box in the index and display the recipe
    # run a test for a clickable element
    get recipes_path
    assert_template 'recipes/index'
    assert_select "a[href=?]", recipe_path(@recipe), text: @recipe.name
    assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
  end

  test "should get recipe show page" do
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_match @recipe.name, response.body
    assert_match @recipe.description, response.body
    assert_match @chef.chefname, response.body
  end
end
