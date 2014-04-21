class Rule < ActiveRecord::Base
	include Partitions

	# Callbacks
	serialize :partitions
	after_initialize :initialize_partitions
	before_save { self.partitions = PartitionCollection.new self.partitions }
	
	# Relations
	belongs_to :analyte
	belongs_to :analyte_group

	# Validations
	#validates :analyte, 				presence: true
	validates :weight, 	presence: true


	def analyte
		Analyte.find analyte_id
	end

	def analyte_group
		AnalyteGroup.find analyte_group_id
	end

end
