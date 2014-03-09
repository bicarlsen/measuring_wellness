class TestsController < ApplicationController
	def index
		@tests = Test.all
	end

	def show
		@test = Test.find params[:id]
	end

	def new
		@test = Test.new
		@users = users_for_select
		#@selected_user = 0
		@orders = orders_for_select
		@analytes = analytes_for_select

		@results = []
		Analyte.all.each do |a|
			@results << @test.results.build( analyte_id: a.id	)
		end
	end

	def create
		@test = Test.new 		
		
		@users = users_for_select
		@user = ( params.has_key?( :user ) ? User.find( params[:user] ) : nil )
		@selected_user = @user.nil? ? @user.id : 0
		@orders = @user ? orders_for_select( @user ) : orders_for_select
		@analytes = analytes_for_select
		@results = []
		params[:results].each do |r|
			@results << @test.results.build(
				analyte_id: r[:analyte_id],
				amount: r[:amount]
			)
		end

		if params[:search_user]	
			render :new
			return
		end
		
		# Remove Untested Results
		params[:results].each do |result| 
			@results.delete_if do |r|
				( r.analyte_id == result[:analyte_id].to_i )
				( result[:not_tested] || result[:amount].empty? )
			end
		end

		order = params[:order]
		@test.order_id = order
		@test.user_id = Order.find( order ).user_id
		@test.results = @results 

		if @test.save
			flash[:success] = "Test Results saved!"
			redirect_to tests_path
		
		else
			flash.now[:error] = "There was an issue creating the Test"
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

		def test_params
			params.require(:test)
		end

		def users_for_select
			users = User.all
			arr = []
			users.each do |u|
				arr << [ u.name, u.id ]
			end

			arr.sort! { |x, y| x[0] <=> y[0] }
		end

		def orders_for_select( user = nil )
			if user.nil?
				orders = Order.all

			else
				orders = user.orders

			end

			arr = []
			orders.each do |o|
				arr << [ "#{o.user.name}: #{o.test_center_id} ( #{o.created_at} )", o.id ]
			end

			arr.sort! { |x, y| x[0] <=> y[0] }
		end

		def analytes_for_select
			analytes = Analyte.all
			arr = []
			analytes.each do |a|
				arr << [ a.name, a.id ]
			end

			arr
		end

end
