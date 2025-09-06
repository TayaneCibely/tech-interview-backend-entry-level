
class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  enum status: { active: 0, abandoned: 1}

  #Calcula o preço total do carrinho de acordo com os itens adicionados
  def total_price
    cart_items.sum(&:total_price)
  end

  def update_last_interaction!
    update!(updated_at: Time.current)
  end

  def add_item(product, quantity)
    result = CartServices::AddItem.call(self, { product_id: product.id, quantity: quantity })
    raise StandardError, result.error unless result.success?
  end
end
