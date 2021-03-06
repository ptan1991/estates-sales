class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    respond_with current_user.orders
  end

  def show
    respond_with current_user.orders.find(params[:id])
  end

  def create
    order = current_user.orders.build
    order.build_order_items_with_product_ids_and_quantities(params[:order][:product_ids_and_quantities])
    if order.save
      order.reload
      render json: order, status: :created, location: [:api, current_user, order]
    else
      render json: { errors: order.errors }, status: :unprocessable_entity
    end
  end

end
