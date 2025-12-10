class AddNamesToEmails < ActiveRecord::Migration[8.1]
  def change
    add_column :emails, :email_from_firstname, :string
    add_column :emails, :email_from_lastname, :string
    add_column :emails, :email_to_firstname, :string
    add_column :emails, :email_to_lastname, :string
  end
end
