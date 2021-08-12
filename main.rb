# frozen_string_literal: true
#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'pg'

# About memo app class
class Memo
  def self.create(title:, content:)
    connection = PG.connect( dbname: 'database-memo' )
    connection.exec("INSERT INTO memotable(title, content) VALUES ('#{title}', '#{content}')")
  end

  def self.find(id:)
    connection = PG.connect( dbname: 'database-memo' )
    connection.exec("SELECT #{id} FROM memotable")
  end

  def self.update(id:, title:, content:)
    connection = PG.connect( dbname: 'database-memo' )
    connection.exec("UPDATE memotable SET id = '#{id}', title = '#{title}', content = '#{content}'")
  end

  def self.destroy(id:)
    connection = PG.connect( dbname: 'database-memo' )
    connection.exec("DELETE FROM memotable WHERE id = '#{id}'")
  end
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/memos' do
  connection = PG.connect( dbname: 'database-memo' )
  @memos = {}
  connection.exec("SELECT * FROM memotable") do |result|
    result.each do |row|
      @memos = { id: SecureRandom.uuid, title: row["title"], content: row["content"] }
    end
  end
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
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
  @memo = Memo.update(id: params[:id], title: h(params[:title]), content: h(params[:content]))
  redirect '/memos'
  erb :edit
end

delete '/memos/:id' do
  Memo.destroy(id: params[:id])
  redirect '/memos'
end

not_found do
  erb :not_found
end
