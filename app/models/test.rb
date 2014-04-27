class Test < ActiveRecord::Base
	# Callbacks
	
	# Relations
	belongs_to :user
	belongs_to :order
	has_many :results
	has_one :consultation
	has_many :evaluations, through: :consultation

	# Validations
	

	# Evalutation Functions
	def evaluate
		session = ConsultationSession.new( self )
		
		# Get triggered Flags
		active_flags = []
		Flag.where(active: true).each do |flag| # only run active Flags
			if flag.triggered? self
				session.add_flag flag
				active_flags << flag
			end
		end

		consultation = self.build_consultation user: self.user, session: session
		
		# Get triggered Reccomendations from Flags
		Recommendation.where(active: true).each do |rec| # Only run active Recs
			if rec.triggered? active_flags
				active_triggers = rec.active_triggers active_flags
				session.add_recommendation rec, active_triggers
				consultation.evaluations << rec.evaluations.create( 
					triggers: active_triggers, severity: rec.severity 
				) 	
			end
		end

		consultation.save
	end

end
