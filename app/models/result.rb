class Result < ActiveRecord::Base
	# Callbacks
	

	# Relations
	belongs_to :analyte
	belongs_to :test

	# Validations
	validates :amount, presence: true

	def test
		Test.find self.test_id
	end

end
