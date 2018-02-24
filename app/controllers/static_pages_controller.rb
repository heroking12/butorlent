class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @test = User.find(session[:user_id])
    end

  end

  def help
    require 'rakuten_web_service'
    require 'net/http'
    require 'uri'
    require 'json'
    require 'open-uri'
    require 'kconv'
    require 'active_support/core_ext/hash/conversions'


  RWS.configuration do |c|
    c.application_id = '1093362645588395413'
  end

  if params[:keyword].present?
   @books = RWS::Books::Book.search(:title =>"#{params[:keyword]}")
 else
   @books = RWS::Books::Book.search(:title =>"実験")
 end

 if logged_in?
   @test = User.find(session[:user_id])
   url  = URI.encode('http://api.calil.jp/library?limit=10'+"&pref=#{@test.pref}"+"&city=#{@test.city}")
   xml  = open( url ).read.toutf8
   @hash = Hash.from_xml(xml)
   @hash['Libraries']['Library'].each do |a|
   @systemid=a['systemid']
   end
 else
   @systemid = "Tokyo_NDL"
 end

 @items=[]
@books.each do |book|
  @data = {}
  uri = URI.parse('http://api.calil.jp/check?appkey={1f797b9d960207280336610120edb44a}&isbn='+"#{book['isbn']}"+'&systemid='+"#{@systemid}"+'&callback=')
  json = Net::HTTP.get(uri)
  json = json.slice(1..-3)
  result = JSON.parse(json)
  uri = URI.parse('http://api.calil.jp/check?session='+"#{result["session"]}"+'&callback=')
  json = Net::HTTP.get(uri)
  json = json.slice(1..-3)
  result = JSON.parse(json)
  @data["title"]="#{book.title}"
  @data["isbn"]="#{book['isbn']}"
  @data["price"]="#{book['itemPrice']}"
  @data["Pref"]="#{book['itemUrl']}"
  @data["libkey"]=result['books']["#{book['isbn']}"]["#{@systemid}"]["libkey"]
  @data["place"]=[]
  @data["reserve"]=result['books']["#{book['isbn']}"]["#{@systemid}"]["reserveurl"]
  @data["img"]=book['mediumImageUrl']
  @items.push(@data)
end


end

  def about
    require 'uri'
    require 'open-uri'
    require 'kconv'
    require 'active_support/core_ext/hash/conversions'

    url  = URI.encode('http://api.calil.jp/library?limit=10'+'&pref=神奈川県')
    xml  = open( url ).read.toutf8
    @hash = Hash.from_xml(xml)


  end

  def contact
    require 'rakuten_web_service'
    require 'net/http'
    require 'uri'
    require 'json'

  RWS.configuration do |c|
    c.application_id = '1093362645588395413'
  end

  if params[:keyword].present?
   @books = RWS::Books::Book.search(:title =>"#{params[:keyword]}")
 else
   @books = RWS::Books::Book.search(:title =>"デフォルト")
 end

    uri = URI.parse('http://api.calil.jp/check?appkey={1f797b9d960207280336610120edb44a}&isbn=9784101001609&systemid=Kanagawa_Atsugi&callback=')
    json = Net::HTTP.get(uri)
    json = json.slice(1..-3)
    result = JSON.parse(json)





  end

  def create
    @book = params[:book]
    @user_id = session[:id] #ログインしたユーザのID
    @book_id = @book.first #特定の本のID
    #book_idに@book_id、user_idに@user_idを入れて、Favoriteモデルに新しいオブジェクトを作る
    @favorite = Favo.new(book_id: @book_id, user_id: @user_id)
    @favorite.save!
  end
end
