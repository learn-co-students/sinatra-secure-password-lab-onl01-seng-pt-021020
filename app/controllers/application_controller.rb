require "./config/environment"
require "./app/models/user"
require 'pry'
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end
  #just renders the homepage

  get "/signup" do
    erb :signup
  end
  #renders or shows the signup page, where user can input data regarding their signup

  post "/signup" do
    if params[:username]=="" || params[:password]==""
      redirect to '/failure'
    end
    #redirect to failure if they enter bad data

    user = User.new(:username => params[:username], :password => params[:password])
    #create a user with the parameters they enter
    
    if user.save
			redirect to "/login"
		else
			redirect to "/failure"
		end
		#if they save to database, take them to the homepage
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end
  #show their account page, and show the correct account page by finding the user based on their session id 


  get "/login" do
    erb :login
  end
  #show the login page

  post "/login" do
    user = User.find_by(:username => params[:username])

		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect to "/account"
		else
			redirect to "/failure"
		end
  end
  #process their login information, and authenticate their password. 

  get "/success" do
    if logged_in?
      erb :success
    else
      redirect to "/login"
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect to "/"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end