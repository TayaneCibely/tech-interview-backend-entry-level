
class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  def total_price
    quantity * unit_price
  end

  def unit_price
    product.price
  end
end
