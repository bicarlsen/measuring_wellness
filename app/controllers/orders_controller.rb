class OrdersController < ApplicationController
	
	def index
		if current_user.admin?
			@orders = Order.all

		else
			@orders = current_user.orders

		end	
	end # index

	def show
		@order = Order.find params[:id]
	end

	def new
		@order = Order.new
	end

	def create
		@order = Order.new order_params
		@order.status = 0;  # Initial status is always 0

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
			params.require(:order).permit :status, :test_center, :promotion_code
		end


end
