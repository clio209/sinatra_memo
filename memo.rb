# frozen_string_literal: true

require 'json'
require 'bundler'
require 'securerandom'

Bundler.require

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  @memo_all_data = []
  Dir.glob('memo/*.json').each do |file|
    @memo_all_data << JSON.parse(File.open(file).read)
  end
  erb :index
end

post '/' do
  id = SecureRandom.uuid
  time = Time.now.strftime('%Y%m%d')
  article = params[:article]
  content = params[:content]
  json = []
  json = { id: id, article: h(article), content: h(content), time: time }
  File.open("memo/#{json[:id]}.json", 'w') do |file|
  JSON.dump(json, file)
  end
  redirect '/'
  # erb :result
end

get '/new' do
  erb :new
end

get '/:id' do
  id = params[:id]
  @detail_memo_data = []
  @detail_memo_data = JSON.parse(File.open("memo/#{id}.json").read)
  erb :detail
end

get '/:id/edit' do
  id = params[:id]
  # @detail_memo_data = []
  @detail_memo_data = JSON.parse(File.open("memo/#{id}.json").read)
  erb :edit
end

get '/:id/delete' do
  id = params[:id]
  @detail_memo_data = []
  @detail_memo_data = JSON.parse(File.open("memo/#{id}.json").read)
  erb :delete
end

patch '/:id' do
  id = params[:id]
  time = Time.now.strftime('%Y%m%d')
  article = params[:article]
  content = params[:content]
  json = []
  json = { id: id, article: h(article), content: h(content), time: time }
  File.open("memo/#{json[:id]}.json", 'w') do |file|
  JSON.dump(json, file)
  end
  redirect '/'
  # erb :result
end

delete '/:id' do
  id = params[:id]
  File.delete("memo/#{id}.json")
  redirect '/'
  # erb :result
end
