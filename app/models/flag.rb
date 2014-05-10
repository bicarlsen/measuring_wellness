class Flag < ActiveRecord::Base
	ANALYTE_PATTERN = Regexp.new 'Analyte\(\d+\)'	

	# Callbacks
	after_initialize { self.archived ||= false }

	# Validations
	validates :name, presence: true
	validate 	:unique_name_among_nonarchived
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

	private

		def unique_name_among_nonarchived
			active_flags = Flag.select( :name ).distinct.where( archived: false )
			active_flags.each do |flag|
				if self.name == flag.name
					errors.add :name, "A Flag with that Name already exists."
					return
				end
			end
		end

end
