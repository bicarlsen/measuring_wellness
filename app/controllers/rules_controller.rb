class RulesController < ApplicationController
	def index
		@rules = Rule.all
	end

	def show
		@rule = Rule.find params[:id]
	end

	def new
		@rule = Rule.new

		@groups = AnalyteGroup.all
		group_select = []
		@groups.each do |group|
			group_select << [group.name, group.id]
		end
		@groups = group_select

		@analytes = Analyte.all
		analyte_select = []
		@analytes.each do |ana|
			analyte_select << [ana.name, ana.id]
		end
		@analytes = analyte_select
	end

	def create
		@group = AnalyteGroup.find params[:analyte_group]
		@analyte = Analyte.find params[:analyte]
		
		initial_params = { default_weight: params[:default_weight] }
		@rule = @group.rules.build initial_params
		@rule.analyte = @analyte

		if @rule.save
			flash[:success] = "Rule created!"
			redirect_to rules_path

		else
			flash[:error] = "There was an error creating your Rule"
			redirect_to new_rule_path
		
		end
	end

	def edit
	end

	def update
	end

	def destroy
	end

	private

		def rule_params
			params.require(:rule).permit :default_weight
		end

end
