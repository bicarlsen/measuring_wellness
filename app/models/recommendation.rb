class Recommendation < ActiveRecord::Base

	# Validations
	validates :name, presence: true, uniqueness: true
	validates :active, presence: true
	validates :summary, presence: true
	validates :description, presence: true
	validates :priority, presence: true
	validates :severity, presence: true
	validates :triggers, presence: true



	# Returns an array of Flags that are included in the triggers
	def required_flags()

	end


end
