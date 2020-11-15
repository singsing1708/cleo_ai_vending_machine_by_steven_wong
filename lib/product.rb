class Product
	attr_reader :code, :name, :quantity, :price

	def initialize(code:, name:, quantity:, price:)
		raise StandardError, 'Code, name, quantity and price cannot be null' unless code && name && quantity && price
		@code = code
		@name = name
		@quantity = quantity
		@price = price
	end

	def to_s
		"#{@code}: #{@name}(#{@quantity}): £#{@price/100.0}"
	end

	def update_quantity(quantity)
		@quantity = @quantity + quantity
	end

end
