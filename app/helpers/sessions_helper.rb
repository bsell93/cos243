module SessionsHelper
	
	def current_user #If @current doesnt exist User.find() will run if the cookie exists
		@current_user ||= User.find(cookies.signed[:user_id]) if cookies[:user_id]
	end
	
	def current_user?(user)
		current_user == user
	end
	
	def logged_in?
		!current_user.nil?
	end

end
