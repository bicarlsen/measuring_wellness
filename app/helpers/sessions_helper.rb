module SessionsHelper
	def sign_in(user)
		token = User.new_remember_token
		cookies.permanent[:remember_token] = token
		user.update_attribute :remember_token, User.encrypt(token)
		self.current_user = user
	end # sign_in

	def sign_out
		self.current_user.update_attribute :remember_token, nil
		cookies.delete :remember_token

		self.current_user = nil
	end # sign_out

	def signed_in?
		!current_user.nil?
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		remember_token = User.encrypt cookies[:remember_token]
		@current_user ||= User.find_by remember_token: remember_token
	end

	def must_be_signed_in
		unless signed_in?
			flash[:notice] = 'Please sign in'
			redirect_to signin_path
		end
	end # must_be_signed_in

	def must_be_signed_out
		if signed_in?
			redirect_to root_path
		end
	end # must_be_signed_out
	
	def must_own_resource
		unless User.find(params[:id]) == current_user
			redirect_to root_path
		end
	end # must_own_resource

end
