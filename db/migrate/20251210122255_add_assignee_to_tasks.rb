class AddAssigneeToTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :tasks, :assignee_id, :integer
    add_index :tasks, :assignee_id
  end
end
