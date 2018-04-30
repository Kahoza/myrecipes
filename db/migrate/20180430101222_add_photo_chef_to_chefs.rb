class AddPhotoChefToChefs < ActiveRecord::Migration[5.1]
  def change
    add_column :chefs, :photo_chef, :string
  end
end
