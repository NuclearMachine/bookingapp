class Reservation < ApplicationRecord
  belongs_to :guest

  validates :code, presence: true, uniqueness: true

  validates :end_date,
    comparison: {
      greater_than: :start_date
    }, on: :create

  validates_presence_of :start_date,
    :end_date,
    :start_date,
    :status,
    :currency,
    :payout_price,
    :security_price,
    :total_price

  validates :start_date, presence: true
  validates :status, presence: true
  validates :currency, presence: true
  validates :payout_price, presence: true
  validates :security_price, presence: true
  validates :total_price, presence: true

  [:nights, :guests, :adults, :children, :infants].each do |reservation_attr|
    validates reservation_attr,
      presence: true,
      numericality: {
        greater_than_or_equal_to: 0
      }
  end
end
