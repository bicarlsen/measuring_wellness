class HomePagesController < ApplicationController
	def index
		if signed_in?
			@user = current_user
			render 'users/home'
		end
	end

	def measures
		@user = current_user if signed_in?
	end

	def homeostasis
		@user = current_user if signed_in?
	end

	def science
	end

end
