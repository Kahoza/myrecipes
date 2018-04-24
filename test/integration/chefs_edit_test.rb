require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: "Karen", email: "karen@example.com",
                        password: "password", password_confirmation: "password")
  end

  test "reject an invalid edit profile" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    # Since we confirm the password, we don't require the chef to provide password again when updating profile
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: {chef: {chefname: " ", email: "karen@example.com"}}
    assert_select 'p.card-title'
    assert_select 'div.card-body'
  end

  test "accept valid edit profile" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    # Since we confirm the password, we don't require the chef to provide password again when updating profile
    patch chef_path(@chef), params: {chef: {chefname: "Karen_new", email: "karen_new@example.com"}}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "Karen_new", @chef.chefname
    assert_match "karen_new@example.com", @chef.email
  end

end
