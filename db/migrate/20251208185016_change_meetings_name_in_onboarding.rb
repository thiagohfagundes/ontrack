class ChangeMeetingsNameInOnboarding < ActiveRecord::Migration[8.1]
  def change
    rename_column :onboardings, :meetings, :meetings_limit
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
