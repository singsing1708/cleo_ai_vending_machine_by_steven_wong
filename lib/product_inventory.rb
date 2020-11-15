class ProductInventory
  def initialize
    @stock = {}
  end

  def products
    @stock.values
  end

  def find_product(code)
    @stock[code]
  end

  def add_product(code:, name:, price:, quantity:)
    if @stock[code]
      raise StandardError.new("Product already exist")
    end
    @stock[code] = Product.new(
      code: code,
      name: name,
      price: price,
      quantity: quantity
    )
  end

  def update_quantity(code, quantity)
    if !@stock[code]
      raise StandardError.new("Product not found")
    end
    @stock[code].update_quantity(quantity)
  end
end
