class RenameTypeTask < ActiveRecord::Migration[8.1]
  def change
    rename_column :tasks, :type, :task_type
  end
end
