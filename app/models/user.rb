class User < ActiveRecord::Base
	# Relations
	has_many :orders
	has_many :results, through: :orders

	# Validations
	before_save { self.email = email.downcase }

	validate :name, presence: true, length: { maximum: 75 }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
		uniqueness: { case_sensitive: false }

	has_secure_password
	validates :password, length: { minimum: 6 }

	# Methods
	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

end
