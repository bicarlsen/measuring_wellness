class Rule < ActiveRecord::Base
	serialize :partitions

	# Relations
	belongs_to :analyte
	belongs_to :analyte_group

	# Validations
	#validates :analyte, 				presence: true
	validates :default_weight, 	presence: true


	def analyte
		Analyte.find analyte_id
	end

	def analyte_group
		AnalyteGroup.find analyte_group_id
	end

end
