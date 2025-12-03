class RemoveItemsFromOnboarding < ActiveRecord::Migration[8.1]
  def change
    remove_column :onboardings, :progress
    remove_column :onboardings, :hubspot_cache
  end
end
