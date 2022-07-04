class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    item = Item.find_by(id: params[:id])
    render json: item
  end

  def create
    user = User.find(params[:user_id])
    item = user.items.create(item_params)
    render json: item, status: created

    # if item.valid?
    #   render json: item, status: created
    # else
    #   render json: { errors: item.errors }, status:
    #   :unprocessable_entity
    # end
    
  end


  private

  def item_params
    params.permit(:name, :description, :price, :user_id, :created_at, :updated_at)
  end

  def render_not_found_response
    render json: { error: "User not found" }, status: :not_found
  end

end
