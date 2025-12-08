class AddLocationToMeeting < ActiveRecord::Migration[8.1]
  def change
    add_column :meetings, :location, :string
  end
end
