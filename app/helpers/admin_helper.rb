module AdminHelper
	def must_be_admin
		current_user.admin?
	end

end
