class AnalyteGroupsController < ApplicationController
	def index
		@groups = AnalyteGroup.all
	end

	def show
		@group = AnalyteGroup.find params[:id]
		@rules = @group.rules
	end

	def new
		@group = AnalyteGroup.new
	end

	def create
		@group = AnalyteGroup.new group_params
		@group.default_weights = []
		params[:analyte_group][:default_weights].each do |weight|
			@group.add_weight(
				weight[:severity].to_i, weight[:weight].to_i 
			)
		end

		# Add Default Weight
		if params[:add_weight]
			@group.add_weight
			render :new
			return
		end

		if @group.save
			flash[:success] = "Analyte Group created!"
			redirect_to analyte_groups_path

		else
			flash.now[:error] = "There was an issue creating your Analyte Group"
			render :new

		end
	end

	def edit
	end

	def update
	end

	def destroy
		group = AnalyteGroup.find params[:id]
		group.destroy
	
		flash[:success] = "Analyte Group destroyed!"
		redirect_to analyte_groups_path
	end

	private

		def group_params
			params.require(:analyte_group).permit :name
		end

end
