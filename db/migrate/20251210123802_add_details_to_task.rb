class AddDetailsToTask < ActiveRecord::Migration[8.1]
  def change
    add_column :tasks, :priority, :string
    add_column :tasks, :reminder, :datetime
    add_reference :tasks, :user, null: false, foreign_key: true
  end
end
