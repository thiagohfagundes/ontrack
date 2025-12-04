class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  has_many :onboardings, dependent: :destroy
  has_many :templates, dependent: :destroy
  has_one_attached :avatar

  def full_name
    [first_name, last_name].compact.join(' ').presence || email
  end
end
