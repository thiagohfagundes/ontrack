class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :subject
      t.text :body
      t.string :status
      t.string :type
      t.datetime :completion_date
      t.datetime :due_date
      t.belongs_to :onboarding, null: false, foreign_key: true

      t.timestamps
    end
  end
end
