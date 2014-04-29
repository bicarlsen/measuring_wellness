class Flag < ActiveRecord::Base
	ANALYTE_PATTERN = Regexp.new 'Analyte\(\d+\)'	

	# Callbacks
	after_initialize { self.archived ||= false }

	# Validations
	validates :name, presence: true, uniqueness: true
	validates :priority, presence: true
	validates :severity, presence: true
	validates :trigger, presence: true

	# Evaluation Functions
	def triggered?( test )
		algebra = TriggerAlgebra.new test
		algebra.triggered? self.trigger
	end

	def calculate_severity( test )
		# Severity is a constant
		return severity if severity.is_a? Numeric

		# Severity is an equation
		algebra = TriggerAlgebra.new test
		algebra.evaluate_expression self.severity
	end

end
