class EvaluationsController < ApplicationController
	before_action :must_be_admin

	def new 
		@consultation = Consultation.find params[:consultation]
		@user = User.find @consultation.user_id
		@evaluation = @consultation.evaluations.build
		@recommendations = recommendations_for_select
	end

	def create
		@consultation = Consultation.find params[:evaluation][:consultation]
		
		evaluation = @consultation.evaluations.build
	 	evaluation.update_attribute( 
			:recommendation, Recommendation.find( params[:evaluation][:recommendation] ))
		evaluation.update_attribute :notes, params[:evaluation][:notes]
		evalutaion.update_attribute :severity, params[:evaluation][:severity]
		evaluation.update_attribute :triggers, 'Added Manually'

		if evaluation.save
			redirect_to edit_consultation_path( @consultation )

		else
			flash.now[:error] = 'There was an error creating the Evaluation'
			render :new
		end

	end

	def edit
	end

	def update
		evaluation = Evaluation.find params[:id]
		consultation = Consultation.find evaluation.test_id

		if evaluation.update_attributes evaluation_params
			flash[:success] = 'Evaluation updated!'
			redirect_to consultation

		else
			flash[:error] = 'There was an issue updating the Evaluation'
			redirect_to consultation

		end
	end

	def destroy
		evaluation = Evaluation.find params[:id]
		consultation = Consultation.find evaluation.consultation_id
		evaluation.update_attribute :removed, true

		flash[:success] = 'Recommendation removed from Consultation'
		redirect_to edit_consultation_path( consultation )
	end

	private

		def evaluation_params
			params.require( :evaluation ).permit :notes, :recommendation, :products
		end

		def recommendations_for_select
			recs = []
			Recommendation.all.each do |rec|
				recs << [ rec.name, rec.id ]
			end

			recs
		end
		
end
