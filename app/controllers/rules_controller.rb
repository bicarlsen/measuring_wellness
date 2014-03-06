require 'severity_weight'

class RulesController < ApplicationController
	def index
		@rules = Rule.all
	end

	def show
		@rule = Rule.find params[:id]
	end

	def new
		@rule = Rule.new
		@groups = analyte_groups_for_select
		@analytes = analytes_for_select
	end

	def create
		@group = AnalyteGroup.find params[:analyte_group]
		@groups = analyte_groups_for_select
		@selected_group = params[:analyte_group]

		@analyte = Analyte.find params[:analyte]			
		@analytes = analytes_for_select
		@selected_analyte = params[:analyte]
		
		init_params = { weight: params[:weight] }
		@rule = @group.rules.build init_params
		@rule.analyte = @analyte

		# Build Partitions
		@rule.partitions = []
		
		# Load Default
		if params[:load_default_partitions]
			@group.default_weights.each do |weight|
				@rule.create_partition(
					weight.severity, weight.severity*50, weight.weight
				)
			end

			render :new
			return
		end

		# Load Custom
		params[:partitions].each do |part|
			@rule.create_partition(
				part[:severity].to_i, part[:threshold].to_i, part[:weight].to_i
			)
		end

		# Add Partition
		if params[:add_partition]
			@rule.create_partition		
			render :new
			return
		end

		if @rule.save
			flash[:success] = "Rule created!"
			redirect_to rules_path

		else
			flash[:error] = "There was an error creating your Rule"
			render :new
		
		end
	end

	def edit
	end

	def update
	end

	def destroy
		rule = Rule.find params[:id]
		rule.destroy

		flash[:success] = "Rule destroyed!"
		redirect_to rules_path
	end

	private

		def rule_params
			params.require(:rule).permit :weight
		end
		
		def analyte_groups_for_select
			groups = AnalyteGroup.all
			group_select = []
			groups.each do |group|
				group_select << [group.name, group.id]
			end
			
			return group_select
		end

		def analytes_for_select
			analytes = Analyte.all
			analyte_select = []
			analytes.each do |ana|
				analyte_select << [ana.name, ana.id]
			end
		
			return analyte_select
		end

end
