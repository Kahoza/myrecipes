class AddPasswordDigestToChefs < ActiveRecord::Migration[5.1]
  def change
    add_column :chefs, :password_digest, :string
  end
end
