class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update]
  before_action :authenticate_user!

  # GET /users
  def index
    query = params[:query] || ""
    status = params[:status]
    @users = User.all.order(lastname: :asc)
    if query
      @users = @users.where("(LOWER(firstname) || ' ' || LOWER(lastname)) LIKE LOWER(?)","%#{query}%")
    end
    if status
      @users = @users.where(status: status)
    end
    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # PATCH/PUT /users/1
  def update

    if user_params[:status] && @current_user.status !="admin"
      render json: {error:"not allowed"},status:401
      return true
    end

    if !(@current_user == @user || @current_user.status == "staff")
      render json: {error: "not allowed"},status:401
      return
    end

    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:firstname, :lastname,:description)
    end


end
