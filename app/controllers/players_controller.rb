class PlayersController < ApplicationController
  before_action :ensure_user_logged_in, only: [:create,:new,:edit,:update,:destroy]
  before_action :ensure_correct_user, only: [:edit,:update]
  
	# /contests/:contest_id/players/new
  def new
		contest = Contest.find(params[:contest_id])
		@player = contest.players.build
  end
  
	# /contests/:contest_id/players
  def create
		contest = Contest.find(params[:contest_id])
		@player = contest.players.build(acceptable_params)
    @player.user = current_user
    if @player.save then
			flash[:success] = "Player #{@player.name} created!"
      redirect_to @player
    else
      render 'new'
    end
  end
  
  def index
    @players = Player.all
  end
  
  def show
    @player = Player.find(params[:id])
  end
  
  def update
    if @player.update_attributes(acceptable_params)
      flash[:success] = "Player #{@player.name} updated successfully!"
      redirect_to @player
    else
      render 'edit'
    end
  end
  
  def edit
  end
  
  def destroy
    @player = Player.find(params[:id])
    if current_user?(@player.user) # If current user is the creator of the player
      @player.destroy
      flash[:success] = "Player successfully deleted!"
      redirect_to contest_players_path(@player.contest)
    else
      flash[:danger] = "Unable to delete the player!"
      redirect_to root_path
    end
  end
  
  
  private	
	def acceptable_params
    params.require(:player).permit(:contest_id, :name, :description, :upload, :downloadable, :playable)
	end
  
  def ensure_user_logged_in
    if !logged_in?
      flash[:warning] = "You are not logged in!"
      redirect_to login_path
    end
  end
  
  def ensure_correct_user
    @player = Player.find(params[:id])
    redirect_to root_path, flash: {danger: "You are not logged in as the correct user!"} unless current_user?(@player.user)
  end
end
