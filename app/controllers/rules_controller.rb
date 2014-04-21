require 'severity_weight'

class RulesController < ApplicationController
	include Partitions

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

		@selected_group = params[:group]
		@selected_analyte = params[:analyte]
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
				part[:severity].to_i, 
				resolve_threshold( part[:threshold] ),
			 	part[:weight].to_f
			)
		end

		# Add Partition
		if params[:add_partition]
			@rule.create_partition		
			render :new
			return
		end

		redirect_if_duplicate_rule @rule 

		if @rule.save
			flash[:success] = "Rule created!"
			redirect_to rules_path

		else
			flash.now[:error] = "There was an error creating your Rule"
			render :new
		
		end
	end

	def edit
		@rule = Rule.find params[:id]
		
		@group = @rule.analyte_group	
		@groups = analyte_groups_for_select
		@selected_group = @group.id

		@analyte = @rule.analyte
		@analytes = analytes_for_select
		@selected_analyte = @analyte.id
	end

	def update
		@rule = Rule.find params[:id]

		if @rule.save
			flash[:success] = "Rule updated!"
			redirect_to @rule

		else
			flash.now[:error] = "There was an error updating your Rule"
			render :edit
		
		end
	
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
		
		def redirect_if_duplicate_rule( rule )
			group = rule.analyte_group
			analyte = rule.analyte

			previous_rule = Rule.where( 
				analyte_group_id: group.id, analyte_id: analyte.id 
			)

			if !previous_rule.empty?
				flash[:error] = "This Rule already exists"
				@rule = previous_rule[0]
				redirect_to edit_rule_path( @rule )
				return
			end
		end

		def resolve_threshold( str )
			return Float::INFINITY if str.downcase == 'infinity'
			str.to_f
		end

end
