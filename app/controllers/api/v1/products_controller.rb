class Api::V1::ProductsController < ApplicationController
  before_action :set_product, only: %i[show update destroy]
  before_action :check_login, only: [ :create ]
  before_action :check_owner, only: %i[ update destroy ]

  # GET /products
  def index
    @products = Product.search(params)
    render json: ProductSerializer.new(@products).serializable_hash.to_json
  end

  # GET /products/1
  def show
    options = { include: [ :user ] }
    render json: ProductSerializer.new(@product, options).serializable_hash.to_json
  end

  # POST /products
  def create
    product = current_user.products.build(product_params)
    if product.save
      render json: ProductSerializer.new(product).serializable_hash.to_json,
        status: :created
    else
      render json: { errors: product.errors },
        status: :unprocessable_entity
    end
  end

  # PATCH /products/1
  def update
    if @product.update(product_params)
      render json: ProductSerializer.new(@product).serializable_hash.to_json,
        status: :ok
    else
      render json: { errors: @product.errors },
        status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
    head :no_content
  end

  private

  def set_product
    @product = Product.find(params[:id])
    head :not_found unless @product
  end

  def product_params
    params.require(:product).permit(:title, :price, :published)
  end

  def check_owner
    head :forbidden unless @product.user_id == current_user&.id
  end
end
