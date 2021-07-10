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
  @memos = []
  conn = PG.connect(dbname: DB_NAME.to_s)
  conn.exec("SELECT * FROM #{TABLE_NAME}") do |result|
  @memos = result.to_a
  # @memos << Hash[*result.map {|n| n}]
    # result.each do |row|
    #   @memos << { id: row['id'], article: row['article'], content: row['content'], time: row['time'] }
    # end
  end
end

def detail_data_create
  # @memo = []
  conn = PG.connect(dbname: DB_NAME.to_s)
  conn.exec("SELECT * FROM #{TABLE_NAME} WHERE id=$1;",[@id]) do |result|
  @memo = result.first || {}i
  # @memo = Hash[*result.map {|n| n}]
    # result.each do |row|
    #   @memo = { id: row['id'], article: row['article'], content: row['content'], time: row['time'] }
    # end
  end
end

get '/' do
  memo_all_data_create
  erb :index
end

post '/' do
  @id = SecureRandom.uuid
  @time = Time.now.strftime('%Y%m%d')
  @article = params[:article]
  @content = params[:content]
  conn = PG.connect(dbname: DB_NAME.to_s)
  conn.exec("INSERT INTO #{TABLE_NAME}(id,article,content,time) VALUES('#{@id}','#{@article}','#{@content}','#{@time}')")
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
  @id = params[:id]
  detail_data_create
  erb :edit
end

patch '/:id' do
  @id = params[:id]
  @time = Time.now.strftime('%Y%m%d')
  @article = h(params[:article])
  @content = h(params[:content])
  conn = PG.connect(dbname: DB_NAME.to_s)
  conn.exec("UPDATE #{TABLE_NAME} SET article ='#{@article}',content='#{@content}',time='#{@time}' WHERE id=$1;", [@id])
  redirect '/'
end

delete '/:id' do
  @id = params[:id]
  conn = PG.connect(dbname: DB_NAME.to_s)
  conn.exec("DELETE FROM #{TABLE_NAME} WHERE id=$1;", [@id])
  redirect '/'
end
