
module CartService
  class RemoveItem < Base
    def call(cart, product_id)
      cart_item = cart.cart_items.find_by(product_id: product_id)

      unless product
        add_error("Product not found", :not_found)
        return self
      end

      cart_item.destroy!
      cart.update_last_interaction!
      success!
      self
    end
  end
end