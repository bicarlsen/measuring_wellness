class Consultation < ActiveRecord::Base
	# Callbacks
	serialize :session
	
	# Relations
	belongs_to :test
	belongs_to :user
	has_many :evaluations
	has_many :recommendations, through: :evaluations

	# Validations
	
end
