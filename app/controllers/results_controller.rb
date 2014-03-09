class ResultsController < ApplicationController
	
	def index
		@results = Result.all
	end

	def show
		@result = Result.find params[:id]
	end

	def new
		@result = Result.new
		@tests = tests_for_select
		@analytes = analytes_for_select
	end

	def create
	end

	def edit
	end

	def update
	end

	def destroy
	end

	private

		def result_params
			params.require( :result ).permit :amount
		end

		def tests_for_select
			tests = Test.all
			arr = []
			tests.each do |t|
				arr << [ "#{t.user.name} - #{t.id}", t.id ]
			end

			arr.sort! { |x, y| x[0] <=> y[0] }
		end

		def analytes_for_select
			analytes = Analyte.all
			arr = []
			analytes.each do |a|
				arr << [ a.name, a.id ]
			end

			arr.sort! { |x, y| x[0] <=> y[0] }
		end

end
