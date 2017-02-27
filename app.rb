#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
  @db=SQLite3::Database.new 'Blog.db'
  @db.results_as_hash = true
end

configure do
  init_db
  @db.execute 'CREATE TABLE IF NOT EXISTS Posts
  ( id INTEGER PRIMARY KEY AUTOINCREMENT,
     created_date DATE,
     content TEXT
     )'

 @db.execute 'CREATE TABLE IF NOT EXISTS Comments
  ( id INTEGER PRIMARY KEY AUTOINCREMENT,
     created_date DATE,
     content TEXT,
     post_id integer
     )'
end

before do
  init_db
end

get '/' do
	@results = @db.execute "select * from Posts order by id desc"	
  erb :index		
end


get '/new' do
  erb :new
end


post '/new' do
   content = params[:content]
   if content.length<3
      @error = "Type post text" 
      erb :new
    else
       
       @db.execute "INSERT INTO Posts(created_date,content) VALUES(datetime(),?)",[content]
       redirect to '/'
       #erb "You typed #{content}"
    end
 
end

get '/details/:id' do
post_id = params[:id]

results = @db.execute "Select * from Posts where id=?",[post_id]
@row = results[0]
@comments = @db.execute "Select * from Comments where post_id=? order by id",[post_id]
erb :details

end


post '/details/:id' do
post_id = params[:id]
content = params[:content]
results = @db.execute "Select * from Posts where id=?",[post_id]
@row = results[0]
@comments = @db.execute "Select * from Comments where post_id=? order by id",[post_id]
if content.length<3
      @error = "Type comment text" 
       erb :details, :locals => {:id => post_id}
    else
 @db.execute "INSERT INTO Comments(created_date,content,post_id) VALUES(datetime(),?,?)",[content,post_id]
 redirect to "/details/#{post_id}"
end

end