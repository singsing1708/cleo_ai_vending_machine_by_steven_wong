require 'wallet'

RSpec.describe Wallet do
  let(:wallet) { Wallet.new }

  describe '#update_quantity' do
    subject { wallet.update_quantity(coin_type, 1) }

    context 'when valid coin_type is provided' do
      let(:coin_type) { '1p' }

      it 'should change quantity' do
        expect { subject }.to change { wallet.coins_bag['1p'] }.from(0).to(1)
      end
    end

    context 'when invalid coin_type is provided' do
      let(:coin_type) { '33p' }

      it 'should change quantity' do
        expect { subject }.to raise_error('Unsupported coin')
      end
    end
  end

  describe '#total_value' do
    subject { wallet.total_value }

    context 'when all coin quantity is zero' do
      it 'should change quantity' do
        expect(subject).to eq(0)
      end
    end

    context 'when 1p coin has 1' do
      before do
        wallet.update_quantity('1p', 1)
      end

      it 'should change quantity' do
        expect(subject).to eq(1)
      end
    end

    context 'when 5p coin has 1' do
      before do
        wallet.update_quantity('5p', 1)
      end

      it 'should change quantity' do
        expect(subject).to eq(5)
      end
    end
  end

  describe '#total_value_for_coin_types' do
    subject { wallet.total_value_for_coin_types(coin_types) }
    before do
      wallet.update_quantity('1p', 1)
      wallet.update_quantity('2p', 1)
      wallet.update_quantity('5p', 1)
      wallet.update_quantity('10p', 1)
      wallet.update_quantity('20p', 1)
      wallet.update_quantity('50p', 1)
      wallet.update_quantity('1£', 1)
      wallet.update_quantity('2£', 1)
    end

    context 'when coin types is ["1p"]' do
      let(:coin_types) { ["1p"] }

      it 'should only show 1p value' do
        expect(subject).to eq(1)
      end
    end

    context 'when coin types is ["2p", "50p"]' do
      let(:coin_types) { ["2p", "50p"] }

      it 'should only show "2p", "50p" value' do
        expect(subject).to eq(52)
      end
    end

    context 'when coin types is ["5p", "50p", "1£", "2£"]' do
      let(:coin_types) { ["5p", "50p", "1£", "2£"] }

      it 'should only show "2p", "50p" value' do
        expect(subject).to eq(355)
      end
    end

    # context 'when 1p coin has 1' do
    #   before do
    #     wallet.update_quantity('1p', 1)
    #   end
    #
    #   it 'should change quantity' do
    #     expect(subject).to eq(1)
    #   end
    # end
    #
    # context 'when 5p coin has 1' do
    #   before do
    #     wallet.update_quantity('5p', 1)
    #   end
    #
    #   it 'should change quantity' do
    #     expect(subject).to eq(5)
    #   end
    # end
  end

end
