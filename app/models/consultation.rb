class Consultation < ActiveRecord::Base
	# Callbacks
	serialize :session
	after_initialize { self.published ||= false }
	
	# Relations
	belongs_to :test
	belongs_to :user
	has_many :evaluations
	has_many :recommendations, through: :evaluations

	# Validations
	
end
