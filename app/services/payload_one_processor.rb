class PayloadOneProcessor < ApplicationService
  attr_accessor :params

  def initialize(params:)
    @params = params || missing_attribute(:params)
  end

  def call
    BookReservation.call(
      params: reservation_details
    )
  end

  private

  def reservation_details
    {
      code: params[:reservation_code],
      start_date: params[:start_date]&.to_date,
      end_date: params[:end_date]&.to_date,
      nights: params[:nights]&.to_i,
      guests: params[:guests]&.to_i,
      adults: params[:adults]&.to_i,
      children: params[:children]&.to_i,
      infants: params[:infants]&.to_i,
      status: params[:status],
      currency: params[:currency],
      payout_price: params[:payout_price]&.to_f,
      security_price: params[:security_price]&.to_f,
      total_price: params[:total_price]&.to_f,
      guest_email: params.dig(:guest, :email),
      guest_first_name: params.dig(:guest, :first_name),
      guest_last_name: params.dig(:guest, :last_name),
      guest_phone_numbers: [params.dig(:guest, :phone)]
    }
  end
end
