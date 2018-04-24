require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: "Karen", email: "karen@example.com",
                        password: "password", password_confirmation: "password")
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

  test "create new valid recipe" do
    sign_in_as(@chef, "password")
    get new_recipe_path
    assert_template 'recipes/new'
    name_of_recipe = "Chicken saute"
    description_of_recipe = "Add chicken, add vegetables, cook for 20 minutes and you are ready!"
    assert_difference 'Recipe.count', 1 do
      post recipes_path, params: {recipe: {name: name_of_recipe, description: description_of_recipe}}
    end
    follow_redirect!
    assert_match name_of_recipe.capitalize, response.body
    assert_match description_of_recipe, response.body
  end

  test "reject invalid recipe" do
    sign_in_as(@chef, "password")
    get new_recipe_path
    assert_template 'recipes/new'
    assert_no_difference 'Recipe.count' do
      # The recipe should be rejected if the name & description are empty
      post recipes_path, params: {recipe: {name: " ", description: " "}}
    end
    assert_template 'recipes/new'
    # If they both show up it means that there are errors
    assert_select 'p.card-title'
    assert_select 'div.card-body'
  end

end
