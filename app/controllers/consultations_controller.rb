class ConsultationsController < ApplicationController
	def index
		@consultations = Consultation.all
	end

	def show
		@consultation = Consultation.find params[:id]
	end

	def create
		consultation = Consultation.new consultation_params
	end

	def edit
		@consultation = Consultation.find params[:id]
	end

	def update
		@consultation = Consultation.find params[:id]
	end

	def destroy
		consultation = Consultation.find params[:id]
	end

	private

		def consultation_params
			params.require(:consultation).permit :user_id, :test_id, :notes, :session
		end

end
