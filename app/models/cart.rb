class Cart < ApplicationRecord
  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  has_many :cart_items, depentent: :destroy
  has_many :products, through: :cart_items

  enum status: { active: 0, abandoned: 1}

  #Calcula o preço total do carrinho de acordo
  def total_price
    cart_items.sum(&:total_price)
  end

  # TODO: lógica para marcar o carrinho como abandonado e remover se abandonado
  def update_last_interaction!
    update!(update_at: Time.current)
  end

end
