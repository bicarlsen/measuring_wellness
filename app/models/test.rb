class Test < ActiveRecord::Base
	# Callbacks
	
	# Relations
	belongs_to :user
	belongs_to :order
	has_many :results
	has_many :recommendations
	
	# Validations

end
