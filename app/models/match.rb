class Match < ActiveRecord::Base
  belongs_to :manager, polymorphic: true
  belongs_to :referee
  belongs_to :contest
  
  has_many :players, through: :player_matches
  has_many :player_matches
  
  validates :manager, presence: true
  validates :status, presence: true
  validates_date :completion, :on_or_before => lambda { Time.now.change(:usec =>0) }, :if => :check_finished_matches
  validates_datetime :earliest_start, :if => :check_started_matches
	validate :check_num_players
  
  def check_finished_matches
    if self.status != "Completed"
      return nil
    else
      return true
    end
  end
  
  def check_started_matches
    if self.status == "Completed"
      return nil
    elsif self.status == "Started"
      return nil
    else
      return true
    end
  end
	
	def check_num_players
		if self.players && self.manager
			if self.players.count != self.manager.referee.players_per_game
				errors.add(:manager, "Too many/few players!")
			end
		end
	end
  
end
