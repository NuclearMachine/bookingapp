class PayloadTwoProcessor < ApplicationService
  attr_accessor :params
  attr_reader :reservation

  def initialize(params:)
    @params = params || missing_attribute(:params)
    @reservation = params[:reservation]
  end

  def call
    BookReservation.call(
      reservation_params: reservation_params,
      guest_params: guest_params
    )
  end

  def reservation_params
    {
      code: reservation[:code],
      start_date: reservation[:start_date]&.to_date,
      end_date: reservation[:end_date]&.to_date,
      nights: reservation[:nights]&.to_i,
      guests: reservation[:number_of_guests]&.to_i,
      adults: reservation[:guest_details][:number_of_adults]&.to_i,
      children: reservation[:guest_details][:number_of_children],
      infants: reservation[:guest_details][:number_of_infants]&.to_i,
      status: reservation[:status_type],
      currency: reservation[:host_currency],
      payout_price: reservation[:expected_payout_amount]&.to_f,
      security_price: reservation[:listing_security_price_accurate]&.to_f,
      total_price: reservation[:total_paid_amount_accurate]&.to_f,
    }
  end

  def guest_params
    {
      guest: {
        email: reservation[:guest_email],
        first_name: reservation[:guest_first_name],
        last_name: reservation[:guest_last_name]
      },
      phone_numbers: reservation[:guest_phone_numbers]
    }
  end
end
