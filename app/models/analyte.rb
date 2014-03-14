class Analyte < ActiveRecord::Base
	include Partitions

	# Callbacks
	serialize :partitions
	after_initialize :initialize_partitions
	before_save { self.partitions.sort! }

	# Relations
	has_many :rules
	has_many :analytes

	# Validations
	validates :name, presence: true

end
