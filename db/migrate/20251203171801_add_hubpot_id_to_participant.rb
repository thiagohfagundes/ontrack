class AddHubpotIdToParticipant < ActiveRecord::Migration[8.1]
  def change
    add_column :participants, :hubspot_id, :string
  end
end
