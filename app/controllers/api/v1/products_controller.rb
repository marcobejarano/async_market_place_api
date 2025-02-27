class Api::V1::ProductsController < ApplicationController
  include Paginable
  before_action :set_product, only: %i[show update destroy]
  before_action :check_login, only: [ :create ]
  before_action :check_owner, only: %i[update destroy]

  # GET /products
  def index
    cache_key = "products_page_#{current_page}_per_#{per_page}_search_#{params.to_json}"

    products_scope = Product.includes(:user).search(params)
    cached_products = Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      products_scope.all
    end

    @products = Kaminari.paginate_array(cached_products)
                        .page(current_page)
                        .per(per_page)

    options = get_links_serializer_options(
      "api_v1_products_path", @products
    )
    options[:include] = [ :user ]

    render json: ProductSerializer.new(@products, options).serializable_hash,
           status: :ok
  end

  # GET /products/:id
  def show
    options = { include: [ :user ] }
    render json: ProductSerializer.new(@product, options).serializable_hash,
           status: :ok
  end

  # POST /products
  def create
    product = current_user.products.build(product_params)
    if product.save
      render json: ProductSerializer.new(product).serializable_hash,
             status: :created
    else
      render json: { errors: product.errors },
             status: :unprocessable_entity
    end
  end

  # PATCH /products/:id
  def update
    if @product.update(product_params)
      render json: ProductSerializer.new(@product).serializable_hash,
        status: :ok
    else
      render json: { errors: @product.errors },
             status: :unprocessable_entity
    end
  end

  # DELETE /products/:id
  def destroy
    @product.destroy
    head :no_content
  end

  private

  def set_product
    @product = Product.find(params[:id])
    render json: { error: "Product not found" },
           status: :not_found unless @product
  end

  def product_params
    params.require(:product).permit(:title, :price, :published)
  end

  def check_owner
    head :forbidden unless @product.user_id == current_user&.id
  end
end
