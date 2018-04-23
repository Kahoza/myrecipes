require 'test_helper'

class RecipeTest < ActiveSupport::TestCase

  def setup
    @chef = Chef.create!(chefname: "karen", email: "karen@example.com",
                         password: "password", password_confirmation: "password")
    @recipe = @chef.recipes.build(name: "paella", description: "great dish for all the family")
  end

  test "recipe without chef should be invalid" do
    @recipe.chef_id = nil
    assert_not @recipe.valid?
  end

  # Test to validate the name of the recipe
  # The same can be done with the description
  test "recipe should be valid" do
    assert @recipe.valid?
  end

  test "name should be present" do
    @recipe.name = " "
    assert_not @recipe.valid?
  end


  # Test to validate the length of the description of the recipe
  test "description shouldn't contain less than 5 characters" do
    @recipe.description = "a" * 3
    assert_not @recipe.valid?
  end

  test "description shouldn't contain more than 500 characters" do
    @recipe.description = "a" * 501
    assert_not @recipe.valid?
  end
end
