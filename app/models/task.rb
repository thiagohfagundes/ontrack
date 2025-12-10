class Task < ApplicationRecord
  belongs_to :onboarding
  belongs_to :assignee, class_name: 'User', optional: true

  def assignee_name
    assignee&.full_name || 'Não atribuído'
  end

end
