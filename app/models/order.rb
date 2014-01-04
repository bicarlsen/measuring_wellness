class Order < ActiveRecord::Base
	# Callbacks
	before_validation :resolve_status
	
	# Relations
	belongs_to :user
	has_one :result

	STATUS = ['recieved', 'authorized', 'processed', 'completed', 'cancelled']
	validates :status, presence: true, inclusion: { in: STATUS }

	validates :user_id, presence: true

	private

		def resolve_status
			if self.status
				if self.status.is_a? Integer
					self.status = STATUS[self.status] if
						self.status.between?( 0, STATUS.length )

				elsif self.status.is_a? String
					self.status.downcase!
				
				end
			end
		end # resolve_status

end
