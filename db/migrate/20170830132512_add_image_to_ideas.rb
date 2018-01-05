class AddImageToIdeas < ActiveRecord::Migration[5.0]
  def change
    add_column :ideas, :image, :string
  end
end
