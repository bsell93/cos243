class UsersController < ApplicationController
	before_action :ensure_user_logged_in,     only: [:edit, :update]
  before_action :ensure_not_logged_in,      only: [:create, :new]
	before_action :ensure_correct_user,       only: [:edit, :update]
	before_action :ensure_admin_user,         only: [:destroy]
  
  respond_to :html, :json, :xml
  
  def index
    @users = User.all
    respond_with(@user)
  end
  
  def new
    @user = User.new
    respond_with(@user)
  end
  
  def create
    @user = User.new(permitted_params)
    if @user.save
      log_in(@user)
      flash[:success] = "Welcome to the site: #{@user.username}"
    end
    respond_with(@user)
  end
    
  def show
    @user = User.find(params[:id])
    respond_with(@user)
  end
    
  def edit
  end
    
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(permitted_params)
      flash[:success] = "You successfully updated your profile."
    end
    respond_with(@user)
  end
  
  def destroy
    @user.destroy
    flash[:success] = "User destroyed."
    respond_with(@user)
  end
    
  private
  def permitted_params
    permitted_params = params.require(:user).permit(:username, :email, :password, :password_confirmation) 
  end
  
  def ensure_user_logged_in
    if !logged_in?
      flash[:warning] = "You are not logged in!"
      redirect_to login_path
    end
  end

  def ensure_not_logged_in
    if logged_in?
      flash[:warning] = "You are logged in!"
      redirect_to root_path
    end
  end
	
	def ensure_correct_user
    @user = User.find(params[:id])
    if !current_user?(@user)
      flash[:danger] = "This is not you."
  		redirect_to root_path
    end
	end
	
	def ensure_admin_user
    @user = User.find(params[:id])
    if !current_user.admin? || current_user?(@user)
      redirect_to root_path, flash: { :danger => "Must be admin!" }
    end
	end
  
end
