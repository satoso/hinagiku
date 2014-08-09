class AddCategoryIdToTasks < ActiveRecord::Migration
  def up
    add_column :tasks, :category_id, :integer
  end
end
