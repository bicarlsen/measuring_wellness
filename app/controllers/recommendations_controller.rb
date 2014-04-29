class RecommendationsController < ApplicationController
	before_action :must_be_admin
	
	def index
		@recommendations = Recommendation.where archived: false
	end

	def show
		@recommendation = Recommendation.find params[:id]
	end

	def new
		@recommendation = Recommendation.new
		@recommendation.active = true

		# Remove
		@flags = Flag.where active: true
	end

	def create
		@recommendation = Recommendation.new recommendation_params
		@recommendation.triggers = []
		params[:triggers].each do |trigger|
			@recommendation.triggers << trigger
		end

		if params[:add_trigger]
			@recommendation.triggers << []
			@flags = Flag.where active: true # Remove
			render :new
			return
		end

		if @recommendation.save
			flash[:success] = "Recommendation created!"
			redirect_to recommendations_path

		else
			flash.now[:error] = "There was an error creating your Recommendation"
			@flags = Flag.where active: true # Remove
			render :new

		end
	end

	def edit
		@recommendation = Recommendation.find params[:id]
	end

	def update
		@recommendation = Recommendation.find params[:id]

		if @recommendation.update_attributes recommendation_edit_params
			flash[:success] = 'Recommendation updated!'
			redirect_to edit_recommendation_path( @recommendation )

		else
			flash.now[:error] = 'There was an error updating the Recommendation'
			render :edit

		end
	end

	def destroy
		rec = Recommendation.find params[:id]
		rec.update_attribute :archived, true
		rec.update_attribute :active, false

		flash[:success] = 'Recommendation archived'
		redirect_to recommendations_path
	end

	private

		def recommendation_params
	 		params.require( :recommendation ).permit :name, :active, :priority, :severity, 
				:summary, :description, :products
		end

		def recommendation_edit_params
			params.require( :recommendation ).permit :name, :active, :archived, :priority,
				:severity, :summary, :description, :products
		end

end
