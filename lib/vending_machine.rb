require_relative './wallet'

class VendingMachine
  def initialize(product_inventory, wallet)
    @product_inventory = product_inventory
    @wallet = wallet
    @credit = 0
  end

  def insert_coin(coin_type)
    @wallet.update_quantity(coin_type, 1)
    @credit += Wallet.coin_type_value(coin_type)
  end

  def purchase_product(product_code)
    product = @product_inventory.find_product(product_code)
    
    raise StandardError, 'Product not exist' unless product
    raise StandardError, 'Insufficient stock' if product.quantity <= 0
    raise StandardError, 'Insufficient fund' if @credit < product.price

    @credit -= product.price
    @product_inventory.update_quantity(product_code, -1)

    return_coins
  end

  def return_coins
    result, remaining_amount = @wallet.cash_out_coins(@credit)
    @credit = remaining_amount
    result
  end

  def update_product_quantity(code, quantity)
    @product_inventory.update_quantity(code, quantity)
  end

  def update_wallet_quantity(coin_code, quantity)
    @wallet.update_quantity(coin_code, quantity)
  end

  def products
    @product_inventory.products
  end

  def wallet_value
    @wallet.total_value
  end

  attr_reader :product_inventory, :wallet, :credit
end
