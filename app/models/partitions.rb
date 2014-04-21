module Partitions
	class Partition
		include Comparable

		attr_accessor :severity
		attr_accessor :threshold
		attr_accessor :weight
		
		def initialize( severity = 0, threshold = 0, weight = 1 )
			@severity = severity
			@threshold = threshold.to_f
			@weight = weight.to_f
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

	end # class Partition

	class PartitionCollection < Array
		def initialize( partitions = [] )
			super partitions
			self.sort!
		end

		def <<( partition )
			self << partition
			self.sort!
		end

		def get_amount_partition( amount )
			self.each do |part|
				return part if amount.to_f <= part.threshold.to_f
			end

			# amount was greater than all thresholds
			return @partitions.last
		end
	end # class PartitionCollection

	def add_partition( new_part = Partition.new )
		self.partitions <<  new_part
	end

	def create_partition( severity = 0, threshold = 0, weight = 1 )
		self.partitions << Partition.new( severity, threshold, weight )
	end

	def initialize_partitions
		self.partitions ||= PartitionCollection.new [ 
			Partition.new( 0, Float::INFINITY, 1 )
		] if self.new_record?
	end

end
