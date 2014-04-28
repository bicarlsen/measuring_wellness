class OrdersController < ApplicationController
	before_action :must_be_signed_in
	before_action :must_accept_terms, except: [:index]

	def index
		if current_user.admin?
			@orders = Order.all

		else
			@orders = current_user.orders
		
		end

		@orders.order(created_at: :asc)	
	end # index

	def show
		@order = Order.find params[:id]
	end

	def new
		@order = Order.new
	end

	def create
		@order = current_user.orders.build order_params
		@order.status = 0;  # Initial status is always 0

		# Invalid Coupon
		if Coupon.where(key: @order.promotion_code).empty?
			flash.now[:error] = 'The Redemption Code you entered is incorrect.'
			render 'new'
			return
		end
	
		# Valid Coupon	
		if @order.save
			flash[:success] = 'Order created!'
			redirect_to root_path

		else
			flash.now[:error] = 'There was an issue processing your order'
			render 'new'

		end
	end

	def edit
		@order = Cider.find params[:id]
	end

	def update
		if @order.update_attributes order_params
			flash[:success] = 'Order updated!'
			redirect_to root_path

		else
			flash.now[:error] = 'There was an error updating your order.'
			render 'now'
		
		end
	end

	def destroy
		order = Order.find params[:id]
		order.destroy

		flash[:success] = 'Order destroyed!'
		redirect_to root_path
	end


	private
			
		def order_params
			params.require(:order).permit :status, :test_center_id, :promotion_code
		end

		def must_accept_terms
			 unless current_user && current_user.terms_of_use
				flash[:error] = "Please accept our Terms of Use before continuing"
				redirect_to terms_of_use_path
			 end
		end
	
end
