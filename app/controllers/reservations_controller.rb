class ReservationsController < ApplicationController
  def execute
    if payload_type_one?
      PayloadOneProcessor.call(params: params)
    elsif payload_type_two?
      PayloadTwoProcessor.call(params: params)
    else
      raise bad_request
    end
  end

  private

  def payload_type_one?
    params[:reservation_code].present?
  end

  def payload_type_two?
    params[:reservation][:code].present?
  end

  def bad_request
    ActionController::BadRequest.new(bad_request_message)
  end

  def bad_request_message
    'Unknown payload type'
  end
end
