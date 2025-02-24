class Api::V1::ProductsController < ApplicationController
  before_action :set_product, only: [ :show ]

  # GET /products
  def index
    render json: Product.all
  end

  # GET /products/1
  def show
    render json: @product
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end
