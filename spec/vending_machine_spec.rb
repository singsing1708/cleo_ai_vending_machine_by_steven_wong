require 'yaml'

require 'product'
require 'product_inventory'
require 'vending_machine'

RSpec.describe VendingMachine do
  let(:vending_machine) { VendingMachine.new(init_product_inventory, wallet) }

  describe '#update_quantity' do
    pending 'todo'
  end

  describe '#increase product quantity' do
    subject { vending_machine.update_product_quantity('1', 10) }

    context 'when increase product "1" quantity to 10' do
      let(:wallet) { init_wallet }

      it 'should return product quantity increased 10' do
        expect { subject }.to change(vending_machine.product_inventory.find_product('1'), :quantity).from(5).to(15)
      end
    end
  end

  describe '#increase coin quantity' do
    subject { vending_machine.update_wallet_quantity('50p', 10) }

    context 'when increase "50p" quantity to 10' do
      let(:wallet) { init_wallet }

      it 'should return coin type increased 10' do
        expect { subject }.to change{vending_machine.wallet.coins_bag['50p']}.from(10).to(20)
      end
    end
  end

  describe '#purchase product' do
    subject { vending_machine.purchase_product('1') }

    context 'when product exists and have enough coins' do
      let(:wallet) { init_wallet }

      it 'should return all coins and customer wallet(credit) is 0' do
        expect(vending_machine.credit).to eq 0
        expect(vending_machine.wallet_value).to eq 3900
        vending_machine.insert_coin('2£')
        expect(vending_machine.credit).to eq 200
        selected_product = vending_machine.product_inventory.find_product('1')

        expect(selected_product.quantity).to eq 5
        expect(selected_product.code).to eq '1'
        expect(selected_product.name).to eq 'Coke'

        subject

        product = vending_machine.product_inventory.find_product('1')

        expect(selected_product.quantity).to eq(5 - 1)
        expect(vending_machine.credit).to eq 0
        expect(vending_machine.wallet_value).to eq(3900 + selected_product.price)
      end
    end

    context 'when product exists and dont have coins to change' do
      let(:wallet) { init_wallet(wallet_name: 'empty') }

      before do
        vending_machine.insert_coin('20p')
        vending_machine.insert_coin('50p')
      end

      it 'should raise error' do
        expect { subject }.to raise_error('Insufficient fund')
      end
    end

    context 'when product exists and have exact amount coins' do
      let(:wallet) { init_wallet(wallet_name: 'empty') }

      before do
        vending_machine.insert_coin('10p')
        vending_machine.insert_coin('20p')
        vending_machine.insert_coin('50p')
      end

      it 'should purchase success' do
        subject

        selected_product = vending_machine.product_inventory.find_product('1')
        expect(selected_product.quantity).to eq 4
        expect(vending_machine.credit).to eq 0
        expect(vending_machine.wallet_value).to eq(80)
      end
    end

    context 'when product exists and have not enough amount coins' do
      let(:wallet) { init_wallet(wallet_name: 'empty') }

      before do
        vending_machine.insert_coin('1p')
        vending_machine.insert_coin('10p')
        vending_machine.insert_coin('20p')
        vending_machine.insert_coin('50p')
      end

      it 'should not have credit left over' do
        returned_coins = subject

        selected_product = vending_machine.product_inventory.find_product('1')
        expect(selected_product.quantity).to eq 4
        expect(vending_machine.wallet_value).to eq(80)
        expect(vending_machine.credit).to eq 0

        expect(returned_coins).to eq({ '1p': 1 })
      end
    end

    context 'when product exists and no available coins return' do
      let(:wallet) { init_wallet(wallet_name: 'empty') }

      before do
        vending_machine.insert_coin('1£')
      end

      it 'should have credit left over' do
        returned_coins = subject

        selected_product = vending_machine.product_inventory.find_product('1')
        expect(selected_product.quantity).to eq 4
        expect(vending_machine.wallet_value).to eq(100)
        expect(vending_machine.credit).to eq 20

        expect(returned_coins).to eq({})
      end
    end

    context 'when product exists and have enough changes' do
      subject { vending_machine.purchase_product('3') }

      let(:wallet) { init_wallet(wallet_name: '4') }

      before do
        vending_machine.insert_coin('10p')
        vending_machine.insert_coin('20p')
        vending_machine.insert_coin('50p')
      end

      it 'should have no credit left over' do
        returned_coins = subject

        selected_product = vending_machine.product_inventory.find_product('3')
        expect(selected_product.quantity).to eq 14
        expect(vending_machine.wallet_value).to eq(80)
        expect(vending_machine.credit).to eq 0

        expect(returned_coins).to eq({ '1p': 4 })
      end
    end
  end

  describe '#return_coins' do
    subject { vending_machine.return_coins }

    let(:wallet) { init_wallet(wallet_name: 'empty') }

    context 'when there is available credit' do
      before do
        vending_machine.insert_coin('10p')
      end

      it 'should return 10p coin' do
        expect(subject).to eq({ '10p': 1 })
      end
    end
  end

  private

  def init_wallet(wallet_name: 'rich')
    wallet = Wallet.new
    YAML.load(File.read("./spec/fixtures/wallet_#{wallet_name}.yml")).each do |coin_types|
      wallet.update_quantity(coin_types[:coin_type], coin_types[:quantity])
    end
    wallet
  end

  def init_product_inventory
    product_inventory = ProductInventory.new
    YAML.load(File.read('./spec/fixtures/product.yml')).each do |product|
      product_inventory.add_product(
        code: product[:code],
        name: product[:name],
        price: product[:price],
        quantity: product[:quantity]
      )
    end
    product_inventory
  end
end
