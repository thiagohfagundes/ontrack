class AddItemsToOnboarding < ActiveRecord::Migration[8.1]
  def change
    add_column :onboardings, :progress, :integer, default: 0, null: false
    add_column :onboardings, :due_date, :datetime
  end
end
