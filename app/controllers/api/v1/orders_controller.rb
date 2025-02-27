class Api::V1::OrdersController < ApplicationController
  include Paginable
  before_action :check_login, only: %i[index show create]

  # GET /orders
  def index
    cache_key = "user_#{current_user.id}_orders_page_#{current_page}_per_#{per_page}"

    orders_scope = current_user.orders
    cached_orders = Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      orders_scope.to_a
    end

    @orders = Kaminari.paginate_array(cached_orders)
                      .page(current_page)
                      .per(per_page)

    options = get_links_serializer_options(
      "api_v1_orders_path", @orders
    )

    render json: OrderSerializer.new(@orders, options).serializable_hash,
           status: :ok
  end

  # GET /orders/:id
  def show
    order = current_user.orders.find(params[:id])

    if order
      options = { include: [ :products ] }
      render json: OrderSerializer.new(order, options).serializable_hash,
             status: :ok
    else
      head :not_found
    end
  end

  # POST /orders
  def create
    order = Order.create!(user: current_user)
    order.build_placements_with_product_ids_and_quantities(
      order_params[:product_ids_and_quantities]
    )

    if order.save
      OrderConfirmationWorker.perform_async(order.id)
      render json: order,
             status: :created
    else
      render json: { errors: order.errors },
             status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(
      product_ids_and_quantities: [ :product_id, :quantity ]
    )
  end
end
