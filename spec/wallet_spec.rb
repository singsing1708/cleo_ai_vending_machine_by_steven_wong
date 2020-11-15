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
end
