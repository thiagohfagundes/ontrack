class AddClosedToOnboarding < ActiveRecord::Migration[8.1]
  def change
    add_column :onboardings, :closed, :boolean, default: false
  end
end
