class Api::V1::ProductsController < ApplicationController
  before_action :set_product, only: %i[show update destroy]
  before_action :check_login, only: [ :create ]
  before_action :check_owner, only: %i[ update destroy ]

  # GET /products
  def index
    render json: Product.all
  end

  # GET /products/1
  def show
    render json: @product
  end

  # POST /products
  def create
    product = current_user.products.build(product_params)
    if product.save
      render json: product, status: :created
    else
      render json: { errors: product.errors },
        status: :unprocessable_entity
    end
  end

  # PATCH /products/1
  def update
    if @product.update(product_params)
      render json: @product
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
