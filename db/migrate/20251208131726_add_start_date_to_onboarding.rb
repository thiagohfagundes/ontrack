class AddStartDateToOnboarding < ActiveRecord::Migration[8.1]
  def change
    add_column :onboardings, :start_date, :datetime
  end
end
