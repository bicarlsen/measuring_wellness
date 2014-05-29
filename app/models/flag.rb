class Flag < ActiveRecord::Base
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
		if has_required_analytes?( test )
			algebra = TriggerAlgebra.new test
			algebra.triggered? self.trigger
		
		else
			false

		end
	end

	def calculate_severity( test )
		# Severity is a constant
		return severity if severity.is_a? Numeric

		# Severity is an equation
		if has_required_analytes?( test )
			algebra = TriggerAlgebra.new test
			algebra.evaluate_expression self.severity

		else
			false

		end
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

		def has_required_analytes?( test ) 
			req_analytes = TriggerAlgebra.required_analytes self.trigger
			test_analytes = []
			test.results.each do |result|
				test_analytes.push result.analyte_id
			end

			req_analytes.each do |analyte|
				return false unless test_analytes.include? analyte
			end

			true # Test has all required Analytes
		end

end
