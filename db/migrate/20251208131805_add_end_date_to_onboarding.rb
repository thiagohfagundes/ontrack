class AddEndDateToOnboarding < ActiveRecord::Migration[8.1]
  def change
    add_column :onboardings, :end_date, :datetime
  end
end
