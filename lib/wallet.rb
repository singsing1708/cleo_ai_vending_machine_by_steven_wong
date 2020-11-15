require 'active_support/core_ext/hash'

class Wallet
  attr_reader :coins_bag

  COIN_TYPE_VALUE_MAP = {
    '1p' => 1,
    '2p' => 2,
    '5p' => 5,
    '10p' => 10,
    '20p' => 20,
    '50p' => 50,
    '1£' => 100,
    '2£' => 200
  }.with_indifferent_access

  def initialize
    @coins_bag = COIN_TYPE_VALUE_MAP.each_with_object({}) do |(coin_type, _amount), result|
      result[coin_type] = 0
    end
  end

  def update_quantity(coin_type, quantity)
    raise StandardError, 'Unsupported coin' unless COIN_TYPE_VALUE_MAP[coin_type]

    @coins_bag[coin_type] += quantity
  end

  def total_value
    @coins_bag.reduce(0) do |result, (coin_type, coin_quantity)|
      result += COIN_TYPE_VALUE_MAP[coin_type] * coin_quantity
    end
  end

  def cash_out_coins(amount)
    result = {}
    remaining_amount = amount

    sorted_coins_bag = @coins_bag.sort_by do |coin_type, _quantity|
      Wallet.coin_type_value(coin_type).to_i
    end.reverse

    sorted_coins_bag.each do |coin_type, quantity|
      coin_value = Wallet.coin_type_value(coin_type)
      next unless remaining_amount >= coin_value && quantity > 0

      number_of_coins = [remaining_amount / coin_value, quantity].min
      remaining_amount -= Wallet.coin_type_value(coin_type) * number_of_coins
      update_quantity(coin_type, -1 * number_of_coins)
      result[coin_type.to_sym] = number_of_coins
    end

    [result, remaining_amount]
  end

  def self.coin_type_value(coin_type)
    raise StandardError, 'Unsupported coin' unless COIN_TYPE_VALUE_MAP[coin_type]

    COIN_TYPE_VALUE_MAP[coin_type]
  end
end
