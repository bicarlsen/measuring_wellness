class ConsultationSession < ActiveRecord::Base
	def initialize( test )
		super
		self.test = test
		self.results = test.results
		self.flags = {}
		self.recommendations = {}
	end


	def add_flag( flag )
		flags[flag.id] = flag.calculate_severity( results )
	end

	def add_recommendation( rec )
		flags = # Flags that triggered the Rec
		severity = rec.calculate_severity()
		recommendations[rec.id] = { flags: flags, severity: severity }
	end

	

end
