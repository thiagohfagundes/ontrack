class Email < ApplicationRecord
  belongs_to :onboarding

  def sender_name
    if email_from_firstname.present? || email_from_lastname.present?
      [email_from_firstname, email_from_lastname].compact.join(' ')
    else
      '—'
    end
  end

  def recipient_name
    if email_to_firstname.present? || email_to_lastname.present?
      [email_to_firstname, email_to_lastname].compact.join(' ')
    else
      '—'
    end
  end
end
