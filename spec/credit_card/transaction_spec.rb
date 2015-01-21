require 'spec_helper'

describe Mondido::CreditCard::Transaction do

  context '#delete' do
    it 'raises NotApplicable' do
      expect{
        Mondido::CreditCard::Transaction.delete(1)
      }.to raise_error(Mondido::Exceptions::NotApplicable)
    end
  end

  context 'list transactions' do
    before(:all) do
      uri = URI.parse(Mondido::Config::URI + '/transactions?limit=2&offset=1')
      uri.user = Mondido::Credentials.merchant_id.to_s
      uri.password = Mondido::Credentials.password.to_s
      json_transactions = File.read('spec/stubs/transactions.json')
      @transactions_array = JSON.parse(json_transactions)

      stub_request(:get, uri.to_s)
        .to_return(status: 200, body: json_transactions, headers: {})

      @transactions = Mondido::CreditCard::Transaction.all(limit: 2, offset: 1)
    end

    it 'lists transactions' do
      expect(@transactions.first).to be_an_instance_of(Mondido::CreditCard::Transaction)
    end
  end

  context 'get transaction' do
    before(:all) do
      uri = URI.parse(Mondido::Config::URI + '/transactions/200')
      uri.user = Mondido::Credentials.merchant_id.to_s
      uri.password = Mondido::Credentials.password.to_s
      json_transaction = File.read('spec/stubs/transaction.json')
      @transaction_hash = JSON.parse(json_transaction)

      stub_request(:get, uri.to_s)
        .to_return(status: 200, body: json_transaction, headers: {})

      json_error = {
        code: 128,
        name: 'errors.transaction.not_found',
        description: 'Transaction not found'
      }
      uri.path = '/transactions/201'
      stub_request(:get, uri.to_s)
        .to_return(status: 404, body: json_error, headers: {})

      @transaction = Mondido::CreditCard::Transaction.get(200)
    end

    context 'valid call' do

      it 'returns a CreditCard::Transaction' do
        expect(@transaction).to be_an_instance_of(Mondido::CreditCard::Transaction)
      end

      it 'has the correct amount' do
        expect(@transaction.amount).to eq(@transaction_hash['amount'])
      end

      it 'has the correct payment_ref' do
        expect(@transaction.payment_ref).to eq(@transaction_hash['payment_ref'])
      end

      it 'generates the correct hash' do
        transaction = Mondido::CreditCard::Transaction.new({
          :merchant_id => Mondido::Credentials.merchant_id.to_s,
          :payment_ref => "PaymentRefValue",
          :customer_ref => "CustomerRefValue",
          :amount => "10.00",
          :currency => "sek",
          :test => true,
          :secret => Mondido::Credentials.secret.to_s
        })

        transaction.set_hash!

        # Calculate hash
        unhashed = [
          Mondido::Credentials.merchant_id.to_s,
          "PaymentRefValue",
          "CustomerRefValue",
          "10.00",
          "sek",
          "test",
          Mondido::Credentials.secret
        ].map(&:to_s)
        hash = Digest::MD5.hexdigest(unhashed.join)

        expect(transaction.hash).to eq(hash)
      end

    end

    context 'invalid call' do
      before(:all) do

        uri = URI.parse(Mondido::Config::URI + '/transactions/201')
        uri.user = Mondido::Credentials.merchant_id.to_s
        uri.password = Mondido::Credentials.password.to_s

        json_error = {
          code: 128,
          name: 'errors.transaction.not_found',
          description: 'Transaction not found'
        }.to_json
        stub_request(:get, uri.to_s)
          .to_return(status: 404, body: json_error, headers: {})

      end
      it 'raises ApiException errors.transaction.not_found' do
        expect{
          Mondido::CreditCard::Transaction.get(201)
        }.to raise_error(Mondido::Exceptions::ApiException, 'errors.transaction.not_found')
      end
    end

  end

  context 'create transaction' do

    before(:all) do
      @attributes = {
        amount: '1.00',
        currency: 'sek',
        card_number: '4111 1111 1111 1111',
        card_holder: 'Jane Doe',
        card_cvv: '200',
        card_expiry: '1120',
        card_type: 'visa',
        payment_ref: "#{Time.now.to_i.to_s(16)}#{Time.now.usec.to_s[0,3]}"
      }
    end

    context 'invalid transaction' do

      it 'raises ValidationException errors.currency.missing' do
        expect{
          Mondido::CreditCard::Transaction.create(@attributes.except(:currency))
        }.to raise_error(Mondido::Exceptions::ValidationException, 'errors.currency.missing')
      end

      it 'raises ValidationException errors.amount.missing' do
        expect{
          Mondido::CreditCard::Transaction.create(@attributes.except(:amount))
        }.to raise_error(Mondido::Exceptions::ValidationException, 'errors.amount.missing')
      end

      it 'raises ValidationException errors.card_number.missing' do
        expect{
          Mondido::CreditCard::Transaction.create(@attributes.except(:card_number))
        }.to raise_error(Mondido::Exceptions::ValidationException, 'errors.card_number.missing')
      end

      it 'raises ValidationException errors.card_cvv.missing' do
        expect{
          Mondido::CreditCard::Transaction.create(@attributes.except(:card_cvv))
        }.to raise_error(Mondido::Exceptions::ValidationException, 'errors.card_cvv.missing')
      end

      it 'raises ValidationException errors.card_expiry.missing' do
        expect{
          Mondido::CreditCard::Transaction.create(@attributes.except(:card_expiry))
        }.to raise_error(Mondido::Exceptions::ValidationException, 'errors.card_expiry.missing')
      end

      it 'raises ValidationException errors.card_type.missing' do
        expect{
          Mondido::CreditCard::Transaction.create(@attributes.except(:card_type))
        }.to raise_error(Mondido::Exceptions::ValidationException, 'errors.card_type.missing')
      end

      it 'raises ValidationException errors.payment_ref.missing' do
        expect{
          Mondido::CreditCard::Transaction.create(@attributes.except(:payment_ref))
        }.to raise_error(Mondido::Exceptions::ValidationException, 'errors.payment_ref.missing')
      end

      it 'raises ApiException errors.payment.declined' do
        uri = URI.parse(Mondido::Config::URI + '/transactions')
        uri.user = Mondido::Credentials.merchant_id.to_s
        uri.password = Mondido::Credentials.password.to_s
        json_transaction = File.read('spec/stubs/transaction.json')
        stub_request(:post, uri.to_s)
          .with(body: hash_including({card_cvv: '201'}))
          .to_return(status: 400, body: '{"name": "errors.payment.declined", "code": 129, "description": "Payment declined" }', headers: {})

        attributes = @attributes.dup
        attributes[:card_cvv] = '201'

        expect{
          Mondido::CreditCard::Transaction.create(attributes)
        }.to raise_error(Mondido::Exceptions::ApiException, 'errors.payment.declined')
      end

    end
    
    context 'valid transaction' do

      before(:all) do
        uri = URI.parse(Mondido::Config::URI + '/transactions')
        uri.user = Mondido::Credentials.merchant_id.to_s
        uri.password = Mondido::Credentials.password.to_s
        json_transaction = File.read('spec/stubs/transaction.json')

        stub_request(:post, uri.to_s)
          .with(body: hash_including({card_cvv: '200'}))
          .to_return(status: 200, body: json_transaction, headers: {})

        @transaction = Mondido::CreditCard::Transaction.create(@attributes)
      end

      it 'is approved' do
        expect(@transaction.status).to eq('approved')
      end

      it 'has no errors' do
        expect(@transaction.errors).to be_empty
      end

    end
  end
end

