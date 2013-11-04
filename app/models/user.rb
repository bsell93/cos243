class User < ActiveRecord::Base
  has_secure_password
	
	has_many :referees
  has_many :contests
  has_many :players
  
  validates :username, presence: true, uniqueness: true, length: {maximum: 20}
  validates :email, presence: true, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
  validates :password, presence: true
end
