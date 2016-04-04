module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!, only: [:create, :update, :destroy]

      def index
        @users = User.all
        render json: @users
      end

      def show
        @user = User.find(params[:id])
        render json: @user
      end

      def create
        @user = User.new(create_params)

        authorize @user

        if @user.save
          render json: @user
        else
          render json: { errors: @user.errors.messages }, status: :unprocessable_entity
        end
      end

      def update
        @user = User.find(params[:id])

        authorize @user

        if @user.update_attributes(update_params)
          render json: @user
        else
          render json: { errors: @user.errors.messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @user = User.find(params[:id])

        authorize @user

        @user.destroy
        render json: @user
      end

      private

      def create_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end

      def update_params
        params.require(:user).permit(:email)
      end
    end
  end
end
