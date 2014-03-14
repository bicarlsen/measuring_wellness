class ResultsController < ApplicationController
	before_action :must_be_admin

	def index
		@results = Result.all
	end

	def show
		@result = Result.find params[:id]
	end

=begin
	def new
		@result = Result.new
		
		@tests = tests_for_select
		@default_test = params[:default_test]
		
		@analytes = analytes_for_select
		@default_analyte = params[:default_analyte] 
	end

	def create
		@result = Result.new result_params
	end

	def edit
		@result = Result.find params[:id]
		@analyte = @result.analyte
		@test = @result.test
		@order = @test.order
		@user = @test.user
	end

	def update
		@result = Result.find params[:id]
		
		if @result.update_attributes( result_params )
			flash[:success] = "Result updated!"
			redirect_to result_path( @result )

		else
			flash.now[:error] = "The Result could not be updated"
			render :edit

		end
	end
=end

	def destroy
		result = Result.find params[:id]
		test = result.test
		result.destroy

		flash[:success] = "Result removed"
		redirect_to test_path( test )
	end

	private

		def result_params
			#params.require( :result ).permit :amount
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
