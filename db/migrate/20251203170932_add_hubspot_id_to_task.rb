class AddHubspotIdToTask < ActiveRecord::Migration[8.1]
  def change
    add_column :tasks, :hubspot_id, :string
  end
end
