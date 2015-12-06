require 'sinatra'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/item_list.db")

class Item
  include DataMapper::Resource

  property :id        , Serial
  property :content   , Text, :required => true
  property :price     , Integer
  property :weight    , Integer
  property :created   , DateTime
end

DataMapper.auto_upgrade!

get '/' do
  @items = Item.all(:order => :created.desc)
  redirect '/new' if @items.empty?
  erb :index #list is display
end

get '/new' do
  @title = "Add Todo list"
  erb :form #form is displayed
end

post '/new' do
  Item.create(:content => params[:content], :price => params[:price], :weight => params[:weight], :created => Time.now)
  @filename = params[:file][:filename]
  file = params[:file][:tempfile]

  File.open("./public/#{@filename}", 'wb') do |f|
    f.write(file.read)
  end
  redirect '/'
end



