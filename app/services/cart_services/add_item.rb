module CartServices
  class AddItem < Base
    def call(cart, params)
      product = Product.find_by(id: params[:product_id])

      unless product
        add_error("Product not found", :not_found)
        return self
      end

      quantity = params[:quantity].to_i

      if quantity <= 0
        add_error("Quantity must be greater than 0")
        return self
      end

      cart_item = cart.cart_items.find_by(product: product)

      if cart_item
        cart_item.quantity += quantity
        cart_item.save!
      else
        if cart.persisted?
          cart.cart_items.create!(product: product, quantity: quantity)
        else
          cart.cart_items.build(product: product, quantity: quantity)
        end
      end

      cart.update_last_interaction!
      success!
      self
    rescue ActiveRecord::RecordInvalid => e
      add_error(e.message)
      self
    end
  end
end