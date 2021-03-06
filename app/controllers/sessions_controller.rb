class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, :only => [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(username: user_params[:username])
    if @user && @user.authenticate(user_params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "Authenticated successfully"
      redirect_to(tweets_path)
    else
      @user = User.new
      flash[:alert] = "Username or password invalid"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to(sessions_new_path)
  end

  def user_params
    params.require(:user).permit(:username, :password)
  end

  def redirect_if_authenticated
    redirect_to(tweets_path) if authenticated?
  end
end
