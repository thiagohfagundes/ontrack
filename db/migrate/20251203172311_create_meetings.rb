class CreateMeetings < ActiveRecord::Migration[8.1]
  def change
    create_table :meetings do |t|
      t.string :title
      t.text :body
      t.datetime :start_time
      t.datetime :end_time
      t.string :outcome
      t.text :internal_notes
      t.string :hubspot_id
      t.belongs_to :onboarding, null: false, foreign_key: true

      t.timestamps
    end
  end
end
