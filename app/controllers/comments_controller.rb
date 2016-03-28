class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]

  def index
    @comments = Comment.all
    render json: @comments
  end

  def show
    @comment = Comment.find(params[:id])
    render json: @comment
  end

  def create
    @comment = Comment.new(create_params)

    authorize @comment

    if @comment.save
      render json: @comment
    else
      render json: { errors: @comment.errors.messages }, status: :unprocessable_entity
    end
  end

  def update
    @comment = Comment.find(params[:id])

    authorize @comment

    if @comment.update_attributes(update_params)
      render json: @comment
    else
      render json: { errors: @comment.errors.messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])

    authorize @comment

    @comment.destroy
    render json: @comment
  end

  private

  def create_params
    params.require(:comment).permit(:content, :user_id, :pallet_id)
  end

  def update_params
    params.require(:comment).permit(:content)
  end
end
