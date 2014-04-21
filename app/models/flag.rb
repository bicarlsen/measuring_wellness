class Flag < ActiveRecord::Base
	ANALYTE_PATTERN = Regexp.new 'Analyte\(\d+\)'	
	
	# Validations
	validates :name, presence: true, uniqueness: true
	validates :active, presence: true
	validates :priority, presence: true
	validates :severity, presence: true
	validates :trigger, presence: true

	# Evaluation Functions
	def triggered?( results )
		# returns true or false if flag is triggerred
		eval sub_values_in( trigger, results )
	end

	def calculate_severity( results )
		return severity if severity.is_a? Numeric # Severity is a constant

		# Severity is an equation
		eval sub_values_in( severity, results )
	end

	# Returns an array of Analytes that are included in the trigger
	def required_analytes()
		TriggerAlgebra.get_analyte_ids( severity )
	end


	private
		
		def sub_result_values( eq, results )
			eq.gsub! ANALYTE_PATTERN do |a_id|
				results.each do |r|
					return r.amount if a_id == r.id
				end	

				raise 'Missing required Result.'
			end

			return severity
		end	

end
