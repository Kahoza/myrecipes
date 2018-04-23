require 'test_helper'

class ChefsShowTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: "Karen", email: "karen@example.com",
                        password: "password", password_confirmation: "password")
    @recipe = Recipe.create(name: "Pancakes", description: "Super easy recipe", chef: @chef)
    # the build method indicates that the current chef is creating the recipe
    @recipe2 = @chef.recipes.build(name: "Tacos", description: "Use corn tortillas")
    @recipe2.save
  end

  test "should get chef show" do
    get chef_path(@chef)
    assert_template 'chefs/show'
    assert_select "a[href=?]", recipe_path(@recipe), text: @recipe.name
    assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
    assert_match @recipe.description, response.body
    assert_match @recipe2.description, response.body
    assert_match @chef.chefname, response.body
  end
end
