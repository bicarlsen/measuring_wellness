module Partitions
	class Partition
		include Comparable

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

		def Partition.model_name
			ActiveModel::Name.new Partition
		end

		def <=>( other )
			self.threshold <=> other.threshold
		end

	end # Partition

	def add_partition( new_part = Partition.new )
		self.partitions << new_part
	end

	def create_partition( severity = 0, threshold = 0, weight = 1 )
		self.partitions << Partition.new( severity, threshold, weight )
	end

	def initialize_partitions
		self.partitions ||= [ Partition.new ] if self.new_record?
	end

end
