class UsersController < ApplicationController
	before_action :must_be_signed_in, except: [:new, :create]
	before_action :must_own_resource, 
		except: [:new, :create, :terms_of_use]
	before_action :must_be_signed_out, only: [:new, :create]

	def home
		@user = current_user
	end

	def profile
		@user = current_user
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new user_params

		if @user.save
			sign_in @user
			redirect_to terms_of_use_path

		else
			render :new

		end
	end # create

	def terms_of_use
		@user = current_user

		if params[:user] 
			agreed = params[:user][:terms_of_use]
			
			if agreed == '1'
				if @user.update_attribute :terms_of_use, params[:user][:terms_of_use]
					flash[:notice] = 'Welcome to Measuring Wellness'
					redirect_to root_path

				else
					flash.now[:error] = "We apologize, there was an error. Please try again."	
					render 'terms_of_use'
				end # end update
			
			else
				flash.now[:error] = "Please accept the Terms of Use before continuing"
				render 'terms_of_use'
			end # end agreed
		end # end params[:user]
	end # end terms_of_use

	def show
		@user = User.find params[:id]
	end
	
	def edit
		@user = User.find params[:id]
	end

	def update
		@user = User.find params[:id]
		
		# Only update Profile params
		if params[:submit_profile]
			# Update each attribute individually to avoid validation errors
			# of mass assignment
			user_profile_params.each do |attr, val|
				unless @user.update_attribute( attr, val )
					# Error updating attribute
					flash.now[:error] = 'There was an error updating your profile'
					render 'profile'
					return
				end
			end

			# All attributes updated successfully
			flash[:success] = 'Your profile has been saved'
			redirect_to root_path
			return
		end
				
		if @user.update_attributes user_params
			flash[:success] = 'Your profile has been saved'
			redirect_to root_path

		else
			flash.now[:error] = 'There was an error updating your profile'
			render 'edit'
			
		end
	end

	private

		def user_params
			params.require(:user).permit :name, :email, :password, :password_confirmation,
				:birth_date, :weight, :height, :gender, :terms_of_use
		end

		def user_profile_params
			attrs = params.require(:user).permit :weight, :height, :gender 
			
			year = 		params[:user]['birth_date(1i)'].to_i
			month = 	params[:user]['birth_date(2i)'].to_i
			day = 		params[:user]['birth_date(3i)'].to_i
			attrs[:birth_date] = Date.new( year, month, day ).to_s

			attrs
		end
	
end
