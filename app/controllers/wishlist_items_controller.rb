class WishlistItemsController < ApplicationController
  before_action :set_client
  before_action :set_wishlist_item, only: [:edit, :update, :destroy]

  def new
    @wishlist_item = @client.wishlist_items.new
  end

  def create
    @wishlist_item = @client.wishlist_items.build(wishlist_item_params)
    if @wishlist_item.save
      redirect_to wishlist_clients_path, notice: 'Wishlist item was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @wishlist_item.update(wishlist_item_params)
      redirect_to wishlist_clients_path, notice: 'Wishlist item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @wishlist_item.destroy
    redirect_to wishlist_clients_path, notice: 'Wishlist item was successfully deleted.'
  end

  private

  def set_client
    @client = Client.find(params[:client_id])
  end

  def set_wishlist_item
    @wishlist_item = @client.wishlist_items.find_by(id: params[:id])
    unless @wishlist_item
      redirect_to wishlist_clients_path, alert: 'Wishlist item not found.'
    end
  end

  def wishlist_item_params
    params.require(:wishlist_item).permit(:item_name, :item_reference, :size, :color, :note)
  end
end
