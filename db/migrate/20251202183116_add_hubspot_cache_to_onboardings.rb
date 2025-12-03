class AddHubspotCacheToOnboardings < ActiveRecord::Migration[8.1]
  def change
    add_column :onboardings, :hubspot_cache, :jsonb, default: {}
    add_column :onboardings, :hubspot_synced_at, :datetime
  end
end
