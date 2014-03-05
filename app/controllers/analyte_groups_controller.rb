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
	end

	private

		def group_params
			params.require(:analyte_group).permit :name, :partitions
		end

end
