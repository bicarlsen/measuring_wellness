class ConsultationSession
	attr_reader :results
	attr_reader :flags
	attr_reader :recommendations

	def initialize( test = nil )
		@test = test
		@results = {}
		@flags = {}
		@recommendations = {}

		if @test
			@test.results.each do |result|
				@results[result.analyte_id] = result.amount
			end
		end
	end

	def add_flag( flag )
		@flags[flag.id] = flag.calculate_severity( @test )
	end

	def add_recommendation( rec, triggers )
		@recommendations[rec.id] = { triggers: triggers, severity: rec.severity }
	end

end
