class AddRoleToParticipant < ActiveRecord::Migration[8.1]
  def change
    add_column :participants, :role, :string
  end
end
