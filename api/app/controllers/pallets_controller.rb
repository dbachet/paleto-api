class PalletsController < ApplicationController

  def index
    @pallets = Pallet.all
    render json: @pallets
  end

  def show
    @pallet = Pallet.find(params[:id])
    render json: @pallet
  end

  def create
    @pallet = Pallet.new(create_params)

    if @pallet.save
      render json: @pallet
    else
      render json: { errors: @pallet.errors.messages }, status: :unprocessable_entity
    end
  end

  def update
    @pallet = Pallet.find(params[:id])

    if @pallet.update_attributes(update_params)
      render json: @pallet
    else
      render json: { errors: @pallet.errors.messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @pallet = Pallet.find(params[:id])
    @pallet.destroy
    render json: @pallet
  end

  private

  def create_params
    params.require(:pallet).permit(:title, :description, :latitude, :longitude, :user_id, comments: [])
  end

  def update_params
    params.require(:pallet).permit(:title, :description, :latitude, :longitude)
  end
end
