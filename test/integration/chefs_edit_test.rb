require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: "Karen", email: "karen@example.com",
                        password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "bill", email: "bill@example.com",
                        password: "password", password_confirmation: "password")
    @admin_user = Chef.create!(chefname: "bill1", email: "bill1@example.com",
                        password: "password", password_confirmation: "password", admin: true)
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

  test "accept edit attempt by admin user" do
    sign_in_as(@admin_user, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: {chef: {chefname: "Karen3", email: "karen3@example.com"}}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "Karen3", @chef.chefname
    assert_match "karen3@example.com", @chef.email
  end

  test "redirect edit attempt by another non-admin user" do
    sign_in_as(@chef2, "password")
    updated_name = "joe"
    updated_email = "joe@email.com"
    patch chef_path(@chef), params: {chef: {chefname: updated_name, email: updated_email}}
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match "Karen", @chef.chefname
    assert_match "karen@example.com", @chef.email
  end

end
