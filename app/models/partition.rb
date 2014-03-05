class Partition
	attr_accessor :severity
	attr_accessor :threshold
	attr_accessor :weight
	
	def initialize( severity = 0, threshold = 0, weight = 1 )
		@severity = severity
		@threshold = threshold
		@weight = weight
	end

	def to_arr
		[ @severity, @threshold, @weight ]
	end

	def to_s
		self.to_arr.to_s
	end

end
