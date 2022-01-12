require 'spec_helper'

RSpec.describe 'Reservations API Endpoint', type: :request do
  describe 'POST /reservations (type 1 payload)' do
    it 'creates a reservation and a guest / updates reservation' do
      expect {
        post_payload_type_one
      }.to change(Reservation, :count).by(1)
        .and change(Guest, :count).by(1)
        .and change(PhoneNumber, :count).by(1)

      reservation = Reservation.first

      expect(reservation.code).to eq('YYY12345678')
      expect(reservation.start_date).to eq('2021-04-14'.to_date)
      expect(reservation.end_date).to eq('2021-04-18'.to_date)
      expect(reservation.nights).to eq(4)
      expect(reservation.guests).to eq(4)
      expect(reservation.adults).to eq(2)
      expect(reservation.children).to eq(2)
      expect(reservation.infants).to eq(0)
      expect(reservation.status).to eq('accepted')
      expect(reservation.currency).to eq('AUD')
      expect(reservation.payout_price).to eq(4200.00)
      expect(reservation.security_price).to eq(500.00)
      expect(reservation.total_price).to eq(4700.00)

      guest = Guest.first

      expect(guest.first_name).to eq('Wayne')
      expect(guest.last_name).to eq('Woodbridge')
      expect(guest.email).to eq('wayne_woodbridge@bnb.com')

      expect(PhoneNumber.first.phone_number).to eq('639123456789')

      # it should also be able to update an existing reservation

      post '/reservations', params: {
        'reservation_code': 'YYY12345678',
        'end_date': '2022-12-14',
        'nights': 10
      }

      reservation = reservation.reload
      expect(reservation.end_date).to eq('2022-12-14'.to_date)
      expect(reservation.nights).to eq(10)
    end
  end

  describe 'POST /reservations (type 2 payload)' do
    it 'creates a reservation and a guest / updates reservation' do
      expect {
        post_payload_type_two
      }.to change(Reservation, :count).by(1)
        .and change(Guest, :count).by(1)
        .and change(PhoneNumber, :count).by(1)

      reservation = Reservation.first

      expect(reservation.code).to eq('XXX12345678')
      expect(reservation.start_date).to eq('2021-03-12'.to_date)
      expect(reservation.end_date).to eq('2021-03-16'.to_date)
      expect(reservation.nights).to eq(4)
      expect(reservation.guests).to eq(4)
      expect(reservation.adults).to eq(2)
      expect(reservation.children).to eq(2)
      expect(reservation.infants).to eq(0)
      expect(reservation.status).to eq('accepted')
      expect(reservation.currency).to eq('AUD')
      expect(reservation.payout_price).to eq(3800.00)
      expect(reservation.security_price).to eq(500.00)
      expect(reservation.total_price).to eq(4300.00)

      guest = Guest.first

      expect(guest.first_name).to eq('Wayne')
      expect(guest.last_name).to eq('Woodbridge')
      expect(guest.email).to eq('wayne_woodbridge@bnb.com')

      expect(PhoneNumber.first.phone_number).to eq('639123456789')

      # it should also be able to update an existing reservation

      post '/reservations', params: {
        'reservation': {
          'code': 'XXX12345678',
          'start_date': '2021-04-15',
          'guest_details': {
            'number_of_adults': 20
          }
        }
      }

      reservation = reservation.reload

      expect(reservation.start_date).to eq('2021-04-15'.to_date)
      expect(reservation.adults).to eq(20)
    end
  end

  def post_payload_type_one
    post '/reservations', params: {
      'reservation_code': 'YYY12345678',
      'start_date': '2021-04-14',
      'end_date': '2021-04-18',
      'nights': 4,
      'guests': 4,
      'adults': 2,
      'children': 2,
      'infants': 0,
      'status': 'accepted',
      'guest': {
        'first_name': 'Wayne',
        'last_name': 'Woodbridge',
        'phone': '639123456789',
        'email': 'wayne_woodbridge@bnb.com'
      },
      'currency': 'AUD',
      'payout_price': '4200.00',
      'security_price': '500',
      'total_price': '4700.00'
    }
  end

  def post_payload_type_two
    post '/reservations', params: {
      'reservation': {
        'code': 'XXX12345678',
        'start_date': '2021-03-12',
        'end_date': '2021-03-16',
        'expected_payout_amount': '3800.00',
        'guest_details': {
          'localized_description': '4 guests',
          'number_of_adults': 2,
          'number_of_children': 2,
          'number_of_infants': 0
        },
        'guest_email': 'wayne_woodbridge@bnb.com',
        'guest_first_name': 'Wayne',
        'guest_last_name': 'Woodbridge',
        'guest_phone_numbers': [
          '639123456789',
          '639123456789'
        ],
        'listing_security_price_accurate': '500.00',
        'host_currency': 'AUD',
        'nights': 4,
        'number_of_guests': 4,
        'status_type': 'accepted',
        'total_paid_amount_accurate': '4300.00'
      }
    }
  end
end
