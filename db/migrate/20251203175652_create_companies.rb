class CreateCompanies < ActiveRecord::Migration[8.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :domain
      t.string :hubspot_id

      t.timestamps
    end
  end
end
