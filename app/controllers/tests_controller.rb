class TestsController < ApplicationController
	before_action :must_be_admin, except: [:index, :show]

	def index
		if current_user.admin?
			@tests = Test.all

		else
			@tests = current_user.tests
		
		end
	end

	def show
		@test = Test.find params[:id]
		@results = @test.results
	end

	def new
		@test = Test.new
		@users = users_for_select
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

		order_id = params[:order]

		# Check if Order already has a test.  If so redirect to edit page.
		order = Order.find order_id
		if order.test
			flash[:error] = "That Order already had Test Results associated with it"
			@order = order
			redirect_to edit_test_path( order.test )
			return
		end	
		
		# Remove Untested Results
		params[:results].each do |result| 
			@results.delete_if do |r|
				( r.analyte_id == result[:analyte_id].to_i )
				( result[:not_tested] || result[:amount].empty? )
			end
		end

	
		@test.order_id = order_id
		@test.user_id = Order.find( order_id ).user_id
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
		@test = Test.find params[:id]
		@results = @test.results
		@remaining_analytes = remaining_analytes_for_select( @test )
	end

	def update
		@test = Test.find params[:id]
		@results = @test.results
		@remaining_analytes = remaining_analytes_for_select( @test )

		if params[:add_result]
			@test.results.create( 
				analyte_id: params[:new_analyte], amount: params[:new_amount] 
			)
			redirect_to edit_test_path( @test )
			return
		end

		params[:results].each do |r|
			result = Result.find r[:id]
			unless result.update_attribute :amount, r[:amount]
				flash.now[:error] = "There was an issue upating the Result"
				render :edit
				returns
			end
		end

		if @test.save
			flash[:success] = "Test updated!"
			redirect_to test_path( @test )

		else
			flash.now[:error] = "There was an error updating the Test"
			render :edit

		end
	end

	def destroy
		test = Test.find params[:id]
		test.destroy

		flash[:success] = "Test destroyed!"
		redirect_to tests_path
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

		def remaining_analytes_for_select( test )
			used = test.results
			used = used.map { |r| r.analyte_id }

			remaining = []
			Analyte.all.each do |a|
				remaining << [ a.name, a.id ] unless 
					used.index( a.id )
			end 

			remaining
		end

end
