require 'product_inventory'

RSpec.describe ProductInventory do
  let(:product_inventory) { ProductInventory.new }

  describe '#products' do
    pending 'todo'
  end

  describe '#find_product' do
    subject { product_inventory.find_product('coke') }

    context 'when product exists' do
      before do
        product_inventory.add_product(code: 'coke', name: 'Coke', price: 1, quantity: 1)
      end

      it 'should return product' do
        expect(subject.code).to eq('coke')
        expect(subject.name).to eq('Coke')
        expect(subject.price).to eq(1)
        expect(subject.quantity).to eq(1)
      end
    end

    context 'when product does not exist' do
      it 'should return nil' do
        expect(subject).to be_nil
      end
    end
  end

  describe '#add_product' do
    subject { product_inventory.add_product(code: 'coke', name: 'Coke', price: 1, quantity: 2) }

    it 'should change products' do
      expect { subject }.to change { product_inventory.products.length }.from(0).to(1)

      new_product = product_inventory.products.last
      expect(new_product.code).to eq('coke')
      expect(new_product.name).to eq('Coke')
      expect(new_product.price).to eq(1)
      expect(new_product.quantity).to eq(2)
    end
  end

  describe '#update_quantity' do
    subject { product_inventory.update_quantity('coke', 1) }

    context 'when product code exist' do
      before do
        product_inventory.add_product(code: 'coke', name: 'Coke', price: 1, quantity: 1)
      end

      it 'should not add new products' do
        expect { subject }.not_to change { product_inventory.products.length }
      end

      it 'should chanage product quantity' do
        expect { subject }.to change { product_inventory.find_product('coke').quantity }.from(1).to(2)
      end
    end

    context 'when product code does not exist' do
      it 'should raise error' do
        expect { subject }.to raise_error('Product not found')
      end
    end
  end
end
