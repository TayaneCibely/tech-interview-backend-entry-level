class CartsController < ApplicationController
  before_action :find_cart, only: [:remove_item, :show]
  before_action :ensure_cart, only: [:create, :add_item]

  # GET /cart
  def show
    render json: cart_response(@cart)
  end

  # POST /cart
  def create
    @cart = find_or_create_cart
    result = CartServices::AddItem.call(@cart, cart_params)

    if result.success?
      render json: cart_response(@cart), status: :created
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  # POST /cart/add_item
  def add_item
    result = CartServices::AddItem.call(@cart, cart_params)

    if result.success?
      render json: cart_response(@cart)
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /cart/:product_id
  def remove_item
    return render json: { error: 'Cart not found' }, status: :not_found unless @cart

    result = CartServices::RemoveItem.call(@cart, params[:product_id])

    if result.success?
      render json: cart_response(@cart)
    else
      render json: { error: result.error }, status: :unprocessable_entity
    end
  end

  private

  def ensure_cart
    @cart = find_or_create_cart
  end

  def find_cart
    @cart = Cart.find_by(id: session[:cart_id]) if session[:cart_id]
  end

  def find_or_create_cart
    if params[:cart_id].present?
      cart = Cart.find_by(id: params[:cart_id])
      return cart if cart&.active?
    end

    if session[:cart_id]
      cart = Cart.find_by(id: session[:cart_id])
      return cart if cart&.active?
    end

    cart = Cart.create!(status: :active)
    session[:cart_id] = cart.id
    cart
  end

  def cart_params
    params.require(:cart_item).permit(:product_id, :quantity)
  rescue ActionController::ParameterMissing
    params.permit(:product_id, :quantity)
  end

  def cart_response(cart)
    {
      id: cart.id,
      products: cart.cart_items.includes(:product).map do |item|
        {
          id: item.product.id,
          name: item.product.name,
          quantity: item.quantity,
          unit_price: item.product.price,
          total_price: item.total_price
        }
      end,
      total_price: cart.total_price
    }
  end

end
