#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
	db = SQLite3::Database.new 'barber.sqlite'
	db.results_as_hash = true
	return db
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS "Customers"
	(
		"Id" INTEGER PRIMARY KEY AUTOINCREMENT,
		"Name" VARCHAR,
		"Phone" VARCHAR, 
		"Datestamp" TEXT, 
		"Color" TEXT, 
		"Barber" TEXT);'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>!!!"			
end

get '/about' do
	@error = 'something'
	erb :about
end

get '/err' do
	erb :err
end

get '/visit' do
	erb :visit
end

post '/visit' do
	erb :visit
	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

	hh = {:username => 'Введите имя', 
		  :phone => 'Введите телефон', 
		  :datetime => 'Введите дату'}
	@error = hh.select {|key,_| params[key] == ""}.values.join(", ") 
	if @error != ''
		return erb :visit
	end
	db = get_db	
	db.execute 'INSERT INTO Customers (Name, Phone, Datestamp, Color, Barber) VALUES ( ?, ?, ?, ?, ?)', [@username, @phone, @datetime, @color, @barber]
	db.close

	erb "User: #{@username}, phone #{@phone}, date & time #{@datetime}, #{@barber}, #{@color}\n"
end 

get '/contacts' do
	erb :contacts
end

post '/contacts' do
	erb :contacts
	@email = params[:email]
	@message = params[:message]

	flag = @email.include? "@"
	if flag == true 
		f1 = File.open './public/contacts.txt','a'
		f1.write "E-mail: #{@email}, Text #{@message}\n"
	end
	erb :contacts
end 

get '/showusers' do
	erb "Hello World"
end
