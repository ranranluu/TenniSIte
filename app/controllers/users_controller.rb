class UsersController < ApplicationController
  def index
    if params[:user].present?
      if params[:user].empty?
        @users = User.all
      else
        @users = User.where('nickname LIKE(?)', "%#{params[:user][:keyword]}%")
      end
    else
      @users = User.all
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    if @user == current_user
      render "edit"
    else
      redirect_to user_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(
      :nickname, :profile_image, :introduction, :playstyle, :like_player, :like_brand)
  end
end
