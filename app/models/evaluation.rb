class Evaluation < ActiveRecord::Base
	# Callbacks
	serialize :triggers

	# Relations
	belongs_to :recommendation
	belongs_to :consultation

	# Validations

end
