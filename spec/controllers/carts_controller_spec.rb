require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  describe "POST /add_items" do
    let(:cart) { Cart.create }
    let(:product) { Product.create(name: "Test Product", price: 10.0) }
    let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }

    context 'when the product already is in the cart' do
      before do
        session[:cart_id] = cart.id
      end
      subject do
        post :add_item, params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.from(1).to(2)
      end
    end
  end
end
