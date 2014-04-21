class Test < ActiveRecord::Base
	# Callbacks
	
	# Relations
	belongs_to :user
	belongs_to :order
	has_many :results
	has_one :consultation
	
	# Validations
	

	# Evalutation Functions
	def evaluate
		session = Session.new( self )
		results = self.results
		
		# Get triggered Flags
		Flag.all.each do |flag| # only run active Flags
			session.add_flag( flag ) if flag.triggered? results
		end

		# Get triggered Reccomendations from Flags
		recommendations = []
		Recommendation.all.each do |rec| # Only run active Recs
			recommendations << rec if rec.triggered? flags
		end
	end

end
