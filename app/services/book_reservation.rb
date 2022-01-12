class BookReservation < ApplicationService
  attr_accessor :reservation_params, :guest_params
  attr_reader :code

  def initialize(reservation_params:, guest_params:)
    @reservation_params = reservation_params || missing_attribute(:reservation_params)
    @code = reservation_params[:code] || missing_attribute(:code)
    @guest_params = guest_params
  end

  def call
    reservation = Reservation.find_by(code: code)
    if reservation.present?
      reservation.update!(reservation_params.compact_blank)
    else
      guest = find_or_create_guest(guest_params)
      assign_phone_numbers(guest, guest_params[:guest_phone_numbers])
      guest.reservations.create!(reservation_params)
    end
  end

  private

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
