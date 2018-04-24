require 'test_helper'

class ChefTest < ActiveSupport::TestCase

  def setup
    @chef = Chef.new(chefname: "Karen", email: "karen@example.com",
                     password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @chef.valid?
  end

  test "name should be present" do
    @chef.chefname = " "
    assert_not @chef.valid?
  end

  test "name should contain less than 30 characters" do
    @chef.chefname = "a" * 31
    assert_not @chef.valid?
  end

  test "email should be provided" do
    @chef.email = " "
    assert_not @chef.valid?
  end

  test "email should have correct format" do
    valid_emails = %w[user@exaple.com KAREN@gmail.com K.first@hotmail.com Peter+Amor@co.uk.org]
    valid_emails.each do |email|
      @chef.email = email
      assert @chef.valid?, "#{email.inspect} should be valid"
    end
  end

  test "should reject invalid email addresses" do
    invalid_emails = %w[karen@example karen@gmail,com test.name@hotmail. peter@bar+foo.com]
    invalid_emails.each do |invalid|
        @chef.email = invalid
        assert_not @chef.valid?, "#{invalid.inspect} should be invalid"
    end
  end

  test "email should be unique and case insensitive" do
    duplicate_ched = @chef.dup
    duplicate_ched. email = @chef.email.upcase
    @chef.save
    assert_not duplicate_ched.valid?
  end

  test "email should be case lowercase before saved in DB" do
    mixed_email = "KaREn@example.com"
    @chef.email = mixed_email
    @chef.save
    assert_equal mixed_email.downcase, @chef.reload.email
  end

  test "password should be present" do
    @chef.password = @chef.password_confirmation = " "
    assert_not @chef.valid?
  end

  test "password should have at least 5 characters" do
    @chef.password = @chef.password_confirmation = "x" * 4
    assert_not @chef.valid?
  end

  test "asociated recipes should be destroyed when deleting a chef" do
    @chef.save
    @chef.recipes.create!(name: "testing destroy", description: "testing destroy function")
    assert_difference 'Recipe.count', -1 do
      @chef.destroy
    end
  end

end
