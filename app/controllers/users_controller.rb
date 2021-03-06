class UsersController < ApplicationController

  def show
    require 'uri'
    require 'open-uri'
    require 'kconv'
    require 'active_support/core_ext/hash/conversions'
    @user = User.find(params[:id])

    #@favorites = Favorite.where("user_id = ?", @user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      #保存の成功をここで扱う。
      flash[:success] = "ようこそ、Buy or Rentへ！！"
      redirect_to @user
    else
      render 'new'
    end


  end

  def edit
    @user = User.find(params[:id])
  end

  private

   def user_params
     params.require(:user).permit(:name, :email, :password,
     :password_confirmation,:pref,:city)
   end
end
