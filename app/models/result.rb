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

	def get_group_severity
		self
	end	

	def get_analyte_severity
		analyte = self.analyte
		partition = analyte.partitions.get_amount_partition self.amount
		partition.severity
	end

end
