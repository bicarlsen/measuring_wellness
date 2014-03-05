class User < ActiveRecord::Base
	# Relations
	has_many :orders
	has_many :results, through: :orders

	# Callbacks
	after_initialize :set_default_role
	before_save { self.email = email.downcase }

	# Validations
	validate :name, presence: true, length: { maximum: 75 }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
		uniqueness: { case_sensitive: false }
	
	USER_ROLES = ['normal', 'admin']
	validates :roles, inclusion: { in: USER_ROLES }

	has_secure_password
	validates :password, length: { minimum: 6 }

	# Methods
	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def admin?
		self.roles == 'admin'
	end


	private

		def set_default_role
			unless USER_ROLES.include? self.roles
				self.roles = USER_ROLES[0]
			end
		end

end
