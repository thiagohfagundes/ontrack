class AddVisibilityToTask < ActiveRecord::Migration[8.1]
  def change
    add_column :tasks, :visibility, :boolean, default: true, null: false
  end
end
