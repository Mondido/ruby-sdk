require 'spec_helper'

describe Mondido::CreditCard::StoredCard do
  context '#get' do
    context 'valid call' do
      before(:all) do
        uri = URI.parse(Mondido::Config::URI + '/stored_cards/300')
        uri.user = Mondido::Credentials.merchant_id.to_s
        uri.password = Mondido::Credentials.password.to_s
        json_stored_card = File.read('spec/stubs/stored_card.json')
        @stored_card_hash = JSON.parse(json_stored_card)
        stub_request(:get, uri.to_s)
          .to_return(status: 200, body: json_stored_card, headers: {})

        @stored_card = Mondido::CreditCard::StoredCard.get(300)
      end

      it 'returns a StoredCard' do
        expect(@stored_card).to be_an_instance_of(Mondido::CreditCard::StoredCard)
      end

      it 'has the correct currency' do
        expect(@stored_card.currency).to eq(@stored_card_hash['currency'])
      end

      it 'has the correct card_type' do
        expect(@stored_card.card_type).to eq(@stored_card_hash['card_type'])
      end

    end

    context 'invalid call' do

    end
  end

  context '#create' do
    before(:all) do
      uri = URI.parse(Mondido::Config::URI + '/stored_cards')
      uri.user = Mondido::Credentials.merchant_id.to_s
      uri.password = Mondido::Credentials.password.to_s
      json_transaction = File.read('spec/stubs/stored_card.json')
      @transaction_hash = JSON.parse(json_transaction)

      stub_request(:post, uri.to_s)
        .to_return(status: 200, body: json_transaction, headers: {})

      @attributes = {
        currency: 'sek',
        card_holder: 'Jane Doe',
        card_number: '4111 1111 1111 1111',
        card_cvv: 200,
        card_expiry: '1224'
      }
    end

    context 'valid' do
      before(:all) do
        @stored_card = Mondido::CreditCard::StoredCard.create(@attributes)
      end

      it 'is a Mondido::CreditCard::StoredCard' do
        expect(@stored_card).to be_an_instance_of(Mondido::CreditCard::StoredCard)
      end

      it 'has the correct card_holder' do
        expect(@stored_card.card_holder).to eq(@attributes[:card_holder])
      end
    end

    context 'invalid' do

    end
  end

  context '#delete' do
    before(:all) do
      uri = URI.parse(Mondido::Config::URI + '/stored_cards/1')
      uri.user = Mondido::Credentials.merchant_id.to_s
      uri.password = Mondido::Credentials.password.to_s
      json_stored_card = File.read('spec/stubs/stored_card.json')
      @stored_card_hash = JSON.parse(json_stored_card)

      stub_request(:delete, uri.to_s)
        .to_return(status: 200, body: json_stored_card, headers: {})
    end

    it 'is a Mondido::CreditCard::StoredCard' do
      stored_card = Mondido::CreditCard::StoredCard.delete(1)
      expect(stored_card).to be_an_instance_of(Mondido::CreditCard::StoredCard)
    end
  end
end
