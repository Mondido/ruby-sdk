require 'spec_helper'

describe Mondido::CreditCard::Refund do
  context 'create' do
    context 'valid' do
      before(:all) do
        uri = URI.parse(Mondido::Config::URI + '/refunds')
        uri.user = Mondido::Credentials::MERCHANT_ID.to_s
        uri.password = Mondido::Credentials::PASSWORD.to_s
        json_refund = File.read('spec/stubs/refund.json')
        @refund_hash = JSON.parse(json_refund)

        stub_request(:post, uri.to_s)
          .to_return(status: 200, body: json_refund, headers: {})

        @attributes = {
          transaction_id: 200,
          amount: '1.00',
          reason: 'Because of test'
        }

        @refund = Mondido::CreditCard::Refund.create(@attributes)
      end

      it 'is a CreditCard::Refund' do
        expect(@refund).to be_an_instance_of(Mondido::CreditCard::Refund)
      end

      it 'has the correct reason' do
        expect(@refund.reason).to eq(@attributes[:reason])
      end
    end
  end
end
