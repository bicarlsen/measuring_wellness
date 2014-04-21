class AdminController < ApplicationController
	def home
		unless current_user.admin?
			redirect_to root_path
		end
	end

	def orders
		@coupons = Coupon.all
	end

	def users
		@users = User.all
	end
end
