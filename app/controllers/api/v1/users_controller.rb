class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  before_action :check_owner, only: %i[update destroy]

  # GET /users/:id
  def show
    cache_key = "user_#{@user.id}_with_products"

    cached_user = Rails.cache.fetch(cache_key, expires_in: 15.minutes) do
      options = { include: [ :products ] }
      UserSerializer.new(@user, options).serializable_hash
    end

    render json: cached_user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: UserSerializer.new(@user).serializable_hash, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH /users/:id
  def update
    if @user.update(user_params)
      render json: UserSerializer.new(@user).serializable_hash, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/:id
  def destroy
    @user.destroy
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:id])
    render json: { error: "User not found" }, status: :not_found unless @user
  end

  def check_owner
    head :forbidden unless @user.id == current_user&.id
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
