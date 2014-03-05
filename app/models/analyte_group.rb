class AnalyteGroup < ActiveRecord::Base
	# Callbacks
	serialize :default_partitions
	after_initialize :initialize_partitions
	
	# Relations
	has_many :rules
	has_many :analytes, through: :rules
	has_many :thresholds

	# Validations
	validates :name, presence: true
	

	private
	
		def initialize_partitions
			self.default_partitions ||= [ Partition.new ]
		end

end
