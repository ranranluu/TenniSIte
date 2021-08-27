class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:user].present?
      if params[:user].empty?
        @users = User.all.order(created_at: :desc)
      else
        @users = User.where('nickname LIKE(?)', "%#{params[:user][:keyword]}%").order(created_at: :desc)
      end
    else
      @users = User.all.order(created_at: :desc)
    end
    @post = current_user.posts.new
  end

  def show
    @user = User.find(params[:id])
    @post = current_user.posts.new
  end

  def edit
    @user = User.find(params[:id])
    if @user == current_user
      render "edit"
    else
      redirect_to user_path(current_user)
    end
    @post = current_user.posts.new
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = 'Your account is deleted'
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit(
      :nickname, :profile_image, :introduction, :playstyle, :like_player, :like_brand)
  end
end
