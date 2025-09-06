require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:product) { Product.create!(name: "Produto Teste", price: 10.0) }
  let(:cart) { Cart.new }

  describe 'add_item' do
    context 'with valid params' do
      it 'creates a new cart with product' do
        expect {
          cart.add_item(product, 2)
          cart.save!
        }.to change(CartItem, :count).by(1)
      end

      it 'adds product to existing cart' do
        cart = Cart.create!
        expect {
          cart.add_item(product, 2)
        }.to change { cart.cart_items.count }.by(1)
      end
    end
  end
end