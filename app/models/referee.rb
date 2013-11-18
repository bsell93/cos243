class Referee < ActiveRecord::Base
  belongs_to :user
  has_many :contests
	has_many :matches, as: :manager
	
  validates :file_location, presence: true
  validates :players_per_game, presence: true, numericality: {greater_than: 0, less_than: 11, only_integer: true}
	validates :rules_url, presence: true, format: {with: /https?:\/\/[\S]+/i}
	validates :name, presence: true
	
	def upload=(uploaded_file)
		if uploaded_file.nil?
			# problem--deal with later
		else
			time_no_spaces = Time.now.to_s.gsub(/\s/, '_')
      file_location = Rails.root.join('code','referees',Rails.env, time_no_spaces).to_s + SecureRandom.hex
			IO::copy_stream(uploaded_file, file_location)
		end
		self.file_location = file_location
	end
	
  before_destroy :delete_file
  
  def delete_file
    File.delete(self.file_location)
  end		
end