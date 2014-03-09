class Analyte < ActiveRecord::Base
	include Partitions

	# Callbacks
	serialize :partitions
	after_initialize :initialize_partitions

	# Relations
	has_many :rules
	has_many :analytes

	# Validations
	validates :name, presence: true

end
