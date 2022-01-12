class BookReservation < ApplicationService
  attr_accessor :params
  attr_reader :code

  def initialize(params:)
    @params = params || missing_attribute(:params)
    @code = params[:code] || missing_attribute(:code)
  end

  def call
    reservation = Reservation.find_by(code: code)
    if reservation.present?
      reservation.update!(reservation_details.compact_blank)
    else
      guest = find_or_create_guest(params)
      assign_phone_numbers(guest, params[:guest_phone_numbers])
      guest.reservations.create!(reservation_details)
    end
  end

  private

  def reservation_details
    {
      code: params[:code],
      start_date: params[:start_date],
      end_date: params[:end_date],
      nights: params[:nights],
      guests: params[:guests],
      adults: params[:adults],
      children: params[:children],
      infants: params[:infants],
      status: params[:status],
      currency: params[:currency],
      payout_price: params[:payout_price],
      security_price: params[:security_price],
      total_price: params[:total_price]
    }
  end

  def find_or_create_guest(params)
    Guest.find_or_create_by!(email: params[:guest_email]) do |g|
      g.first_name = params[:guest_first_name]
      g.last_name = params[:guest_last_name]
    end
  end

  def assign_phone_numbers(guest, phone_numbers)
    phone_numbers.each do |number|
      guest.phone_numbers.find_or_create_by(phone_number: number)
    end
  end
end
