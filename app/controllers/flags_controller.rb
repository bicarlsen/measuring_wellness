class FlagsController < ApplicationController
	before_action :must_be_admin
	
	def index
		@flags = Flag.all
	end

	def show
		@flag = Flag.find params[:id]
	end

	def new
		@flag = Flag.new
		@flag.active = true
	end

	def create
		@flag = Flag.new flag_params

		if @flag.save
			flash[:success] = "Flag created!"
			redirect_to flags_path

		else
			flash.now[:error] = "There was an issue creating your Flag"
			render :new

		end
	end

	def edit
	end

	def update
	end

	def destroy
	end

	private
		
		def flag_params
			params.require( :flag ).permit :name, :active, :priority, :severity, :trigger
		end

end
