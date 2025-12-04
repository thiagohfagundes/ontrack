class AddUserToTemplate < ActiveRecord::Migration[8.1]
  def change
    add_reference :templates, :user, null: false, foreign_key: true
  end
end
