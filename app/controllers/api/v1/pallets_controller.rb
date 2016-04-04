module Api
  module V1
    class PalletsController < ApplicationController
      before_action :authenticate_user!, only: [:create, :update, :destroy]

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

        authorize @pallet

        if @pallet.save
          render json: @pallet
        else
          render json: { errors: @pallet.errors.messages }, status: :unprocessable_entity
        end
      end

      def update
        @pallet = Pallet.find(params[:id])

        authorize @pallet

        if @pallet.update_attributes(update_params)
          render json: @pallet
        else
          render json: { errors: @pallet.errors.messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @pallet = Pallet.find(params[:id])

        authorize @pallet

        @pallet.destroy
        render json: @pallet
      end

      private

      def create_params
        ActiveModelSerializers::Deserialization.jsonapi_parse!(params.to_unsafe_h)
      end
      alias_method :update_params, :create_params
    end
  end
end
