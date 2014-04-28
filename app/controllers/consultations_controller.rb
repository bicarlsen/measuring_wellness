require 'consultation_session'
require 'test'

class ConsultationsController < ApplicationController
	before_action :must_be_admin, except: [ :show ]

	def index
		@consultations = Consultation.all
	end

	def show
		@consultation = Consultation.find params[:id]
		
		unless @consultation.published
			flash[:error] = "We're sorry, this Consultation has not been made available yet."
			redirect_to orders_path
		end
		
		@evaluations = @consultation.evaluations.where( removed: false )
		@test = Test.find @consultation.test_id
		@results = @test.results
		@order = Order.find @test.order_id
	end

	def create
		@consultation = Consultation.new consultation_params
	end

	def edit
		@consultation = Consultation.find params[:id]
	end

	def update
		@consultation = Consultation.find params[:id]
		
		if params[:delete_evaluation]
			evaluation = @consultation.evaluations.find params[:evaluation][:id]
			evaluation.destroy

			flash[:success] = 'Evaluation destroyed!'
			redirect_to @consultation
		end

		success = true
		success = false unless
			@consultation.update_attributes consultation_edit_params 
			
		params[:consultation][:evaluation].each do |id, e_fields|
			evaluation = Evaluation.find id
			success = false unless 
				evaluation.update_attribute :notes, e_fields[:notes]
		end

		if success
			flash[:success] = "The Consultation was updated!"
			redirect_to tests_path

		else
			flash.now[:error] = "There was an error updating the Consultation"
			render :edit

		end
	end

	def destroy
		consultation = Consultation.find params[:id]
		test = Test.find consultation.test_id
		consultation.destroy

		flash[:success] = 'Consultation destroyed!'
		redirect_to test
	end

	private

		def consultation_params
			params.require( :consultation ).permit :user_id, :test_id, :notes, :session
		end

		def consultation_edit_params
			params.require( :consultation ).permit :notes, :published
		end

end
