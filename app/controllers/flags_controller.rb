class FlagsController < ApplicationController
	before_action :must_be_admin
	
	def index
		@flags = Flag.where archived: false
	end

	def show
		@flag = Flag.find params[:id]
	end

	def new
		@flag = Flag.new
		@flag.active = true

		# Remove
		@analytes = Analyte.all
		@groups = AnalyteGroup.all
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
		@flag = Flag.find params[:id]
	end

	def update
		@flag = Flag.find params[:id]
		if @flag.update_attributes flag_edit_params
			flash[:success] = 'Flag has been updated!'
			redirect_to edit_flag_path( @flag )

		else
			flash.now[:error] = 'There was an issue updating the Flag'
			render :edit

		end
	end

	# Never delete flag info
	# Save it for later analysis
	def destroy
		flag = Flag.find params[:id]
		flag.update_attribute :archived, true
		flag.update_attribute :active, false

		flash[:success] = 'Flag archived.'
		redirect_to flags_path
	end

	private
		
		def flag_params
			params.require( :flag ).permit :name, :active, :priority, :severity, :trigger
		end

		def flag_edit_params
			params.require( :flag ).permit :name, :active, :priority, :severity, :archived
		end
end
