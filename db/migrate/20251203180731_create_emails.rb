class CreateEmails < ActiveRecord::Migration[8.1]
  def change
    create_table :emails do |t|
      t.string :from_email
      t.string :to_email
      t.string :email_status
      t.string :subject
      t.text :body_text
      t.text :body_html
      t.string :email_direction
      t.datetime :timestamp
      t.belongs_to :onboarding, null: false, foreign_key: true

      t.timestamps
    end
  end
end
