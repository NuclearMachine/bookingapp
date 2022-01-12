class Guest < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_many :reservations, dependent: :destroy
  has_many :phone_numbers, dependent: :destroy

  validates :email,
    presence: true,
    length: { maximum: 255 },
    format: {
      with: VALID_EMAIL_REGEX
    },
  uniqueness: true
end
