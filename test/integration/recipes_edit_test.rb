require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: "karen", email: "karen@example.com")
    @recipe = Recipe.create(name: "Pancakes", description: "Super easy recipe", chef: @chef)
  end

  test "reject invalid recipe update" do
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    patch recipe_path(@recipe), params: {recipe: {name: " ", description: "some description"}}
    assert_template 'recipes/edit'
    assert_select 'p.card-title'
    assert_select 'div.card-body'
  end

  test "successfully added a recipe" do
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    updated_name = "updated recipe name"
    updated_description = "updated recipe description"
    patch recipe_path(@recipe), params: {recipe: {name: updated_name, description: updated_description}}
    assert_redirected_to @recipe # Same as follow_redirect!
    assert_not flash.empty?
    @recipe.reload
    assert_match updated_name, @recipe.name
    assert_match updated_description, @recipe.description
  end
end
