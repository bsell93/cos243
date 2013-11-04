class Match < ActiveRecord::Base
  belongs_to :manager, polymorphic: true
  belongs_to :referee
  belongs_to :contest
  
  has_many :players, through: :player_matches
  has_many :player_matches
  
  validates :manager, presence: true
end
