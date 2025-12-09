class AddConfigToOnboarding < ActiveRecord::Migration[8.1]
  def change
    add_column :onboardings, :info_visible, :boolean, default: true
    add_column :onboardings, :emails_visible, :boolean, default: true
    add_column :onboardings, :participants_visible, :boolean, default: true
    add_column :onboardings, :notes_visible, :boolean, default: true
    add_column :onboardings, :meetings_visible, :boolean, default: true
    add_column :onboardings, :progress_visible, :boolean, default: true
    add_column :onboardings, :dates_visible, :boolean, default: true
  end
end
