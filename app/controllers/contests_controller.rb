class ContestsController < ApplicationController
  before_action :ensure_user_logged_in, only: [:create,:new,:edit,:update,:destroy]
  before_action :ensure_contest_creator, only: [:create,:new,:edit,:update]
  before_action :ensure_correct_user, only: [:edit,:update]
  
  def new
    @contest = current_user.contests.build
  end
  
  def create
    @contest = current_user.contests.build(acceptable_params)
    if @contest.save then
      flash[:success] = "Contest #{@contest.name} created!"
      redirect_to @contest
    else
      render 'new'
    end
  end
  
  def index
    @contests = Contest.all
  end
  
  def show
    @contest = Contest.find(params[:id])
  end
  
  def update
    if @contest.update_attributes(acceptable_params)
      flash[:success] = "Your contest #{@contest.name} was updated successfully!"
      redirect_to @contest
    else
      render 'edit'
    end
  end
  
  def edit
  end
  
  def destroy
    @contest = Contest.find(params[:id])
    if current_user?(@contest.user) # If current user is the creator of the contest
      @contest.destroy
      flash[:success] = "Contest successfully deleted!"
      redirect_to contests_path
    else
      flash[:danger] = "Unable to delete the contest!"
      redirect_to root_path
    end
  end
  
  
  private	
	def acceptable_params
    params.require(:contest).permit(:referee_id, :name, :contest_type, :description, :start, :deadline)
	end
  
  def ensure_user_logged_in
    if !logged_in?
      flash[:warning] = "You are not logged in!"
      redirect_to login_path
    end
  end
  
  def ensure_contest_creator
    redirect_to root_path, flash: {danger: "You are not a contest creator!" } unless current_user.contest_creator?
  end
  
  def ensure_correct_user
    @contest = Contest.find(params[:id])
    redirect_to login_path, flash: {danger: "You are not logged in as the correct user!"} unless current_user?(@contest.user)
  end
end
