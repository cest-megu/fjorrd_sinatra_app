# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'json'

# About memo app class
class Memo
  def self.create(title:, content:)
    memo_contents = { id: SecureRandom.uuid, title: title, content: content }
    File.open("./memos/#{memo_contents[:id]}.json", 'w') { |file| file.puts JSON.pretty_generate(memo_contents) }
  end

  def self.find(id:)
    JSON.parse(File.open("./memos/#{id}.json").read, symbolize_names: true)
  end

  def update(id:, title:, content:)
    new_contents = { id: id, title: title, content: content }
    File.open("./memos/#{new_contents[:id]}.json", 'w') { |file| file.puts JSON.pretty_generate(new_contents) }
  end

  def destroy(id:)
    File.delete("./memos/#{id}.json")
  end
end

get '/memos' do
  memo_list = Dir.glob('./memos/*')
  # binding.pry
  @memos = memo_list.map { |memo| JSON.parse(File.read(memo), symbolize_names: true) }
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos/new' do
  Memo.create(title: params[:title], content: params[:content])
  redirect '/memos'
  erb :new
end

get '/memos/:id' do
  @memo = Memo.find(id: params[:id])
  erb :show
end

get '/memos/:id/edit' do
  @memo = Memo.find(id: params[:id])
  erb :edit
end

patch '/memos/:id' do
  @memo = Memo.new.update(id: params[:id], title: params[:title], content: params[:content])
  redirect '/memos'
  erb :edit
end

delete '/memos/:id' do
  Memo.new.destroy(id: params[:id])
  redirect '/memos'
end

not_found do
  erb :not_found
end
