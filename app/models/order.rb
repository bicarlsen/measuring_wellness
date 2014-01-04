class Order < ActiveRecord::Base
	# Callbacks
	before_validation :resolve_status
	
	# Relations
	has_one :user
	has_one :result

	STATUS = ['recieved', 'authorized', 'processed', 'completed', 'cancelled']
	validates :status, presence: true, inclusion: { in: STATUS }

	private

		def resolve_status
			if self.status
				if self.status.is_a? Integer
					self.status = STATUS[self.status] if
						self.status.included? (0...STATUS.length)

				elsif self.status.is_a? String
					self.status.downcase!
				
				end
			end
		end # resolve_status

end
