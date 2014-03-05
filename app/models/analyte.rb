class Analyte < ActiveRecord::Base
	# Relations
	has_many :rules

	# Validations
	validates :name, presence: true

end
