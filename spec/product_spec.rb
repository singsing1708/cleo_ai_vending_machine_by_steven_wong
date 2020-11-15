require 'product'

RSpec.describe Product do

  describe "#new" do
    subject { Product.new(code: 'coke', name: 'Coke', quantity: 1, price: nil) }
    it "should return error if price is null" do
      expect{subject}.to raise_error('Code, name, quantity and price cannot be null')
    end

    subject { Product.new(code: 'coke', name: 'Coke', quantity: nil, price: 1) }
    it "should return error if quantity is null" do
      expect{subject}.to raise_error('Code, name, quantity and price cannot be null')
    end

    subject { Product.new(code: 'coke', name: nil, quantity: nil, price: 1) }
    it "should return name if quantity is null" do
      expect{subject}.to raise_error('Code, name, quantity and price cannot be null')
    end

    subject { Product.new(code: nil, name: 'Coke', quantity: nil, price: 1) }
    it "should return error if code is null" do
      expect{subject}.to raise_error('Code, name, quantity and price cannot be null')
    end
  end

  describe "#to_s" do
    let(:product) { Product.new(code: 'coke', name: 'Coke', quantity: 1, price: 1) }
    subject { product.to_s }

    it "should return long description" do
      expect(subject).to eq "coke: Coke(1): £0.01"
    end
  end

  describe "#update_quantity" do
    let(:product) { Product.new(code: 'coke', name: 'Coke', quantity: 1, price: 1) }
    subject { product.update_quantity(1) }

    it "should change quantity" do
      expect{ subject }.to change(product, :quantity).from(1).to(2)
    end
  end
end
