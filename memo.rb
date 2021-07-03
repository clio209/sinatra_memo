# frozen_string_literal: true

require 'json'
require 'bundler'
require 'securerandom'

Bundler.require

require 'pg'
DB_NAME = 'sinatra_db'
TABLE_NAME = 'memos'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def memo_all_data_create
  @memo_all_data = []
  conn = PG.connect(dbname: DB_NAME.to_s)
  conn.exec("SELECT * FROM #{TABLE_NAME}") do |result|
    result.each do |row|
      @memo_all_data << { id: row['id'], article: row['article'], content: row['content'], time: row['time'] }
    end
  end
end

def detail_data_create
  @detail_memo_data = []
  conn = PG.connect(dbname: DB_NAME.to_s)
  conn.exec("SELECT * FROM #{TABLE_NAME} WHERE id = '#{@id}'") do |result|
    result.each do |row|
      @detail_memo_data = { id: row['id'], article: row['article'], content: row['content'], time: row['time'] }
    end
  end
end

get '/' do
  memo_all_data_create
  erb :index
end

post '/' do
<<<<<<< HEAD
  @id = SecureRandom.uuid
  @time = Time.now.strftime('%Y%m%d')
  @article = h(params[:article])
  @content = h(params[:content])
  conn = PG.connect(dbname: DB_NAME.to_s)
  conn.exec("INSERT INTO #{TABLE_NAME}(id,article,content,time) VALUES('#{@id}','#{@article}','#{@content}','#{@time}')")
=======
  id = SecureRandom.uuid
  time = Time.now.strftime('%Y%m%d')
  article = params[:article]
  content = params[:content]
  json = []
  json = { id: id, article: article, content: content, time: time }
  File.open("memo/#{json[:id]}.json", 'w') do |file|
  JSON.dump(json, file)
  end
>>>>>>> master
  redirect '/'
end

get '/new' do
  erb :new
end

get '/:id' do
  @id = params[:id]
  detail_data_create
  erb :detail
end

get '/:id/edit' do
<<<<<<< HEAD
  @id = params[:id]
  detail_data_create
=======
  id = params[:id]
  @detail_memo_data = JSON.parse(File.open("memo/#{id}.json").read)
>>>>>>> master
  erb :edit
end

get '/:id/delete' do
  @id = params[:id]
  detail_data_create
  erb :delete
end

patch '/:id' do
<<<<<<< HEAD
  @id = params[:id]
  @time = Time.now.strftime('%Y%m%d')
  @article = h(params[:article])
  @content = h(params[:content])
  conn = PG.connect(dbname: DB_NAME.to_s)
  conn.exec("UPDATE #{TABLE_NAME} SET article ='#{@article}',content='#{@content}',time='#{@time}' WHERE id=$1;", [@id])
=======
  id = params[:id]
  time = Time.now.strftime('%Y%m%d')
  article = params[:article]
  content = params[:content]
  json = []
  json = { id: id, article: h(article), content: h(content), time: time }
  File.open("memo/#{json[:id]}.json", 'w') do |file|
  JSON.dump(json, file)
  end
>>>>>>> master
  redirect '/'
end

delete '/:id' do
<<<<<<< HEAD
  @id = params[:id]
  conn = PG.connect(dbname: DB_NAME.to_s)
  conn.exec("DELETE FROM #{TABLE_NAME} WHERE id=$1;", [@id])
=======
  id = params[:id]
  File.delete("memo/#{id}.json")
>>>>>>> master
  redirect '/'
end
