class AddCategoryToMicroposts < ActiveRecord::Migration[5.1]
  def change
    add_column :microposts, :category, :string
    add_column :microposts, :title, :string
  end
end
