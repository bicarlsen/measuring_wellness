class AnalytesController < ApplicationController
	before_action :must_be_admin
	
	def index
		@analytes = Analyte.all
	end

	def show
		@analyte = Analyte.find params[:id]
		@rules = @analyte.rules
	end

	def new
		@analyte = Analyte.new
	end

	def create
		@analyte = Analyte.new analyte_params
		@analyte.partitions = [] # Reset partitions for clean slate
		params[:analyte][:partitions].each do |part|
			@analyte.create_partition(
				part[:severity].to_i, part[:threshold].to_i, part[:weight].to_i
			)
		end

		# Add Partition
		if params[:add_partition]
			@analyte.create_partition
			render :new
			return
		end

		if @analyte.save
			flash[:success] = "Analyte created!"
			redirect_to analytes_path

		else
			flash.now[:error] = 'There was an error creating the analyte'
			render :new
		
		end
	end

	def edit
	end

	def update
	end

	def destroy
		analyte = Analyte.find params[:id]
		analyte.destroy

		flash[:success] = "Analyte destroyed!"
		redirect_to analytes_path
	end

	private

		def analyte_params
			params.require(:analyte).permit :name
		end

end
