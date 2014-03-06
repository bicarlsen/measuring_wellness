class SeverityWeight
	include Comparable

	attr_accessor :severity
	attr_accessor :weight

	def initialize( severity = 0, weight = 1 )
		@severity = severity
		@weight = weight
	end

	def to_arr
		[ @severity, @weight ]
	end

	def to_s
		self.to_arr.to_s
	end

	def SeverityWeight.model_name
		ActiveModel::Name.new SeverityWeight
	end

	def <=>( other )
		self.severity <=> other.severity
	end

end
