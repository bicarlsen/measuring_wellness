class Result < ActiveRecord::Base
	# Callbacks
	

	# Relations
	belongs_to :analyte
	belongs_to :test

	# Validations
	validates :amount, presence: true

end
