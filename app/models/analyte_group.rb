require 'severity_weight'
class AnalyteGroup < ActiveRecord::Base
	# Callbacks
	serialize :default_weights
	after_initialize :initialize_partitions
	
	# Relations
	has_many :rules
	has_many :analytes, through: :rules
	has_many :thresholds

	# Validations
	validates :name, presence: true


	def add_weight( severity = 0, weight = 1 )
		self.default_weights << SeverityWeight.new( severity, weight )
		#self.default_weights.sort!
	end	

	private
	
		def initialize_partitions
			self.default_weights ||= [ SeverityWeight.new ] if self.new_record?
		end

end
