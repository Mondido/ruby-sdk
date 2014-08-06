require 'spec_helper'

describe Mondido::StoredCard do
 context '#get' do
   context 'valid call' do
     
   end

   context 'invalid call' do

   end
 end

 context '#create' do
   before(:all) do
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
      @stored_card = Mondido::StoredCard.create(@attributes)
    end

    it 'is a Mondido::StoredCard' do
      expect(@stored_card).to be_an_instance_of(Mondido::StoredCard)      
    end

    it 'has the correct card_holder' do
      expect(@stored_card.card_holder).to eq(@attributes[:card_holder])
    end
   end

   context 'invalid' do

   end
 end
end
