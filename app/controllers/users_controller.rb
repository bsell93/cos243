class UsersController < ApplicationController
	before_action :ensure_user_logged_in,     only: [:edit, :update]
  before_action :ensure_user_not_logged_in, only: [:create, :new]
	before_action :ensure_correct_user,       only: [:edit, :update]
	before_action :ensure_admin_user,         only: [:destroy]
  
  def index
    @users = User.all
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(permitted_params)
    if @user.save
      log_in(@user)
      flash[:success] = "Welcome to the site: #{@user.username}"
      redirect_to @user
    else
      render 'new'
    end
  end
    
  def show
    @user = User.find(params[:id])
  end
    
  def edit
  end
    
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(permitted_params)
      flash[:success] = "You successfully updated your profile."
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if !current_user?(@user)
      @user.destroy
      flash[:success] = "You successfully deleted #{@user.username}."
      redirect_to users_path
    else
      flash[:danger] = "You can't delete yourself!!!"
      redirect_to root_path
    end
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

  def ensure_user_not_logged_in
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
    redirect_to users_path, flash: {:danger => "Must be admin!"} unless current_user.admin?
	end
  
end
