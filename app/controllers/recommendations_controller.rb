class RecommendationsController < ApplicationController
	before_action :must_be_admin
	
	def index
		@recommendations = Recommendation.all
	end

	def show
		@recommendation = Recommendation.find params[:id]
	end

	def new
		@recommendation = Recommendation.new
		@recommendation.active = true
	end

	def create
		@recommendation = Recommendation.new recommendation_params

		if @recommendation.save
			flash[:success] = "Recommendation created!"
			redirect_to recommendations_path

		else
			flash.now[:error] = "There was an error creating your Recommendation"
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

		def recommendation_params
	 		params.require( :recommendation ).permit :name, :active, :priority, :severity, 
				:summary, :description, :products, :triggers
		end

end
