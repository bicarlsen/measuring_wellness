class Coupon < ActiveRecord::Base
	# Set Table Name
	self.table_name = "settings"
	self.inheritance_column = nil

	# Default Scope
	default_scope { where "type='coupon'" } 
	
	# Callbacks
	before_validation { self.type = "coupon" }
	
	
	# Validations
	validates :type, presence: true
	validates :key, presence: true
	validates :value, presence: true
end
