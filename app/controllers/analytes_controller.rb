class AnalytesController < ApplicationController
	before_action :must_be_admin
	
	def index
		@analytes = Analyte.all
		@new_analyte = Analyte.new
	end

	def new
		@analyte = Analyte.new
	end

	def create
		@analyte = Analyte.new analyte_params

		if @analyte.save
			flash[:success] = "Analyte created!"
			redirect_to analytes_path

		else
			flash.now[:error] = 'There was an error creating the analyte'
			render :index
		
		end
	end

	def destroy
		analyte = Analyte.find params[:id]
		analyte.destroy

		flash[:success] = "Analyte destroyed!"
		redirect_to admin_path
	end


	private

		def analyte_params
			params.require(:analyte).permit :name
		end

end
