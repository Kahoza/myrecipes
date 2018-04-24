class AddAdminToChefs < ActiveRecord::Migration[5.1]
  def change
    add_column :chefs, :admin, :boolean, default: false
  end
end
