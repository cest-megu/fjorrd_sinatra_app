# frozen_string_literal: true

# !/usr/bin/env ruby

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'pg'

# About memo app class
class Memo
  @connection = PG.connect(dbname: 'database-memo')

  def self.create(title:, content:)
    @connection.exec("INSERT INTO memotable(id, title, content)
    VALUES ($1, $2, $3)", [SecureRandom.uuid, title, content])
  end

  def self.find(id:)
    @connection.exec('SELECT * FROM memotable WHERE id = $1', [id])[0]
  end

  def self.update(id:, title:, content:)
    @connection.exec('UPDATE memotable SET title = $1, content = $2 WHERE id = $3',
                     [title, content, id])[0]
  end

  def self.destroy(id:)
    @connection.exec('DELETE FROM memotable WHERE id = $1', [id])[0]
  end
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/memos' do
  @memos = []
  connection = PG.connect(dbname: 'database-memo')
  connection.exec('SELECT * FROM memotable') do |result|
    result.each do |row|
      @memos << { id: row['id'], title: row['title'], content: row['content'] }
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
  @memo = Memo.update(id: params[:id], title: params[:title], content: params[:content])
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
