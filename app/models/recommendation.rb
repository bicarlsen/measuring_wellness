class Recommendation < ActiveRecord::Base
	# Callbacks
	serialize :triggers
	after_initialize { self.triggers ||= [''] }
	before_save { self.archived ||= false }

	# Relations
	has_many :evaluations

	# Validations
	validates :name, presence: true, uniqueness: true
	validates :active, presence: true
	validates :summary, presence: true
	validates :description, presence: true
	validates :priority, presence: true
	validates :severity, presence: true
	validates :triggers, presence: true

	# Methods

	def active_triggers( flags )
		active_triggers = []
		triggers.each do |trigger|
			active_triggers << trigger if active_trigger?( trigger, flags )
		end

		active_triggers
	end

	def triggered?( flags )
		!active_triggers( flags ).empty?
	end

	private
			
		FLAG_PATTERN = Regexp.new 'Flag\((\d+)\)'		
		
		def active_trigger?( trigger, flags )
			trigger_ids = []
			trigger_flags = trigger.scan FLAG_PATTERN
			trigger_flags.each { |match| trigger_ids << match[0].to_i }

			flag_ids = []
			flags.each { |flag| flag_ids << flag.id }

			trigger_ids.each do |trigger_id|
				return false unless flag_ids.include? trigger_id
			end

			return true
		end 

end
