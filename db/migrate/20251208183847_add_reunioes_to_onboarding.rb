class AddReunioesToOnboarding < ActiveRecord::Migration[8.1]
  def change
    add_column :onboardings, :meetings, :integer
  end
end
