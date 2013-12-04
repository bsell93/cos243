class Referee < ActiveRecord::Base
  belongs_to :user
  has_many :contests
	has_many :matches, as: :manager
	
  validates :players_per_game, presence: true, numericality: {greater_than: 0, less_than: 11, only_integer: true}
	validates :rules_url, presence: true, format: {with: /https?:\/\/[\S]+/i}
  validates :name, presence: true, uniqueness: true
	
	include Uploadable
  
  def referee
    self
  end
  
end