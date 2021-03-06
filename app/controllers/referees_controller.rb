class RefereesController < ApplicationController
  before_action :ensure_user_logged_in, only: [:new,:create,:edit,:update,:destroy]
  before_action :ensure_contest_creator, only: [:new,:create,:edit,:update]
  before_action :ensure_correct_user, only: [:edit,:update]
	
	def new
		@referee = current_user.referees.build
	end
	
  def create
    @referee = current_user.referees.build(acceptable_params)
    if @referee.save then
      flash[:success] = "Referee #{@referee.name} created!"
      redirect_to @referee
    else
      render 'new'
    end
  end
  
  def update
    if @referee.update_attributes(acceptable_params)
      flash[:success] = "Referee #{@referee.name} update successful!"
      redirect_to @referee
    else
      render 'edit'
    end
  end
  
  def edit
  end
  
  def index
    @referees = Referee.all
  end
	
	def show
		@referee = Referee.find(params[:id])
	end

  def destroy
    @referee = Referee.find(params[:id])
    if current_user?(@referee.user) # Ensures current user owns this referee
      @referee.destroy
      flash[:success] = "Referee deleted successfully!"
      redirect_to referees_path
    else
      flash[:danger] = "Unable to delete referee!"
      redirect_to root_path
    end
  end
		
  
  
	private	
	def acceptable_params
		params.require(:referee).permit(:name, :rules_url, :players_per_game, :upload)
	end
  
  def ensure_user_logged_in
    redirect_to login_path, flash: { :warning => "Please log in!" } unless logged_in?
  end
  
  def ensure_contest_creator
    redirect_to root_path, flash: {danger: "You are not a contest creator!" } unless current_user.contest_creator?
  end
  
  def ensure_correct_user
    @referee = Referee.find(params[:id])
    redirect_to root_path, flash: {danger: "You are not logged in as the correct user!"} unless current_user?(@referee.user)
  end
end
