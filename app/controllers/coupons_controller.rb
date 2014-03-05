class CouponsController < ApplicationController
	def new
  	@coupon = Coupon.new
	end

	def create
  	@coupon = Coupon.new coupon_params

		if @coupon.save
			redirect_to admin_orders_path
		else
			render :new
		end
	end

  def destroy
		coupon = Coupon.find params[:id]
		coupon.destroy

		flash[:success] = 'Coupon deleted!'
		redirect_to admin_orders_path
  end


	private
		
		def coupon_params
			params.require(:coupon).permit :type, :key, :value
		end

end
