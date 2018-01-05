class FavoritesController < ApplicationController
  def create
    @user = User.find_by(session[:id])
    @user_id = session[:id] #ログインしたユーザのID
    @book_id = 123456 #特定の本のID
    #book_idに@book_id、user_idに@user_idを入れて、Favoriteモデルに新しいオブジェクトを作る
    @favorite = Favorite.new(book_id: @book_id, user_id: @user_id)
    if @favorite.save
      #保存に成功した場合、本一覧画面に戻る
      redirect_to @user
    end
  end

  #お気に入り削除用アクション
  def destroy
    @favorite = Favorite.find(params[:id])
    if @favorite.destroy
      #削除に成功した場合、ログインしているユーザの詳細画面に戻る
    @user = User.find_by(session[:id])
      redirect_to @user
    end
  end
end
