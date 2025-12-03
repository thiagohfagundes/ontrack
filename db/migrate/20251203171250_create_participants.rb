class CreateParticipants < ActiveRecord::Migration[8.1]
  def change
    create_table :participants do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :phone
      t.string :jobtitle
      t.belongs_to :onboarding, null: false, foreign_key: true

      t.timestamps
    end
  end
end
