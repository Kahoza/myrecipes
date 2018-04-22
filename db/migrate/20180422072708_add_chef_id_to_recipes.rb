class AddChefIdToRecipes < ActiveRecord::Migration[5.1]
  def change
    add_column :recipes, :chef_id, :integer
  end
end
