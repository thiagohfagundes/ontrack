class CreateOnboardings < ActiveRecord::Migration[8.1]
  def change
    create_table :onboardings do |t|
      t.string :title
      t.text :description
      t.belongs_to :user, null: false, foreign_key: true
      t.string :hubspot_id

      t.timestamps
    end
  end
end
