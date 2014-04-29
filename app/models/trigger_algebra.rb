class TriggerAlgebra
	attr_reader :test
	attr_reader :term_values

	def initialize( test )
		@test = test
		@term_values = {}
	end

	def triggered?( equation )
		eval resolve_equation( equation )
	end

	def evaluate_expression( exp )
		eval resolve_expression( exp )
	end

	def results
		test.results
	end
	
#	private
		EQUALITY_PATTERN = Regexp.new '>=|<=|!=|>|<|=='

		ANALYTE_PATTERN = Regexp.new 'Analyte\((\d+)\)'
		GROUP_PATTERN 	= Regexp.new 'Group\((\d+)\)'
		RULE_PATTERN  = Regexp.new "#{GROUP_PATTERN}.#{ANALYTE_PATTERN}"

		IDENTIFIER_PATTERN = Regexp.new(
			"#{ANALYTE_PATTERN}|#{GROUP_PATTERN}" 
		)
		QUALIFIED_IDENTIFIER_PATTERN = Regexp.new(
			"#{RULE_PATTERN}"
		)

		OBJECT_PATTERN = Regexp.new(
			"#{IDENTIFIER_PATTERN}|#{QUALIFIED_IDENTIFIER_PATTERN}"
		)

		ANALYTE_PROPERTY_PATTERN = Regexp.new(
			'amount|severity'
		)
		GROUP_PROPERTY_PATTERN = Regexp.new(
			'weighted_amount|weighted_severity|severities|amount|severity|weight'
		)
		RULE_PROPERTY_PATTERN = Regexp.new(
			'weighted_amount|weighted_severity|weight|severity'
		)

		ANALYTE_TERM_PATTERN = Regexp.new(
			"#{ANALYTE_PATTERN}.#{ANALYTE_PROPERTY_PATTERN}"
		)
		GROUP_TERM_PATTERN = Regexp.new(
			"#{GROUP_PATTERN}.#{GROUP_PROPERTY_PATTERN}"
		)
		RULE_TERM_PATTERN = Regexp.new(
			"#{RULE_PATTERN}.#{RULE_PROPERTY_PATTERN}"
		)

		TERM_PATTERN = Regexp.new(
			"#{ANALYTE_TERM_PATTERN}|#{GROUP_TERM_PATTERN}|#{RULE_TERM_PATTERN}"
		)
	
		#--- Resolutions ---

		def resolve_equation( eq )
			eq_match = EQUALITY_PATTERN.match eq
			parts = eq.split EQUALITY_PATTERN
			lhs = resolve_expression parts[0]
			rhs = resolve_expression parts[1]

			str = lhs + eq_match[0] + rhs
			return str
		end

		def resolve_expression( exp )
			while (match = TERM_PATTERN.match exp)
				start = match.begin 0
				
				# Replace expression with value
				exp.slice! start, match[0].length 
				resolved_term = resolve_term match[0]
				exp.insert start, resolved_term.to_s 
			end

			exp
		end
	
		#--- Term Resolution ---
		
		def resolve_term( term )
			# Order due to greediness of Reexp matching
			return resolve_rule_term( term ) if 
				/^#{RULE_TERM_PATTERN}$/.match( term )

			return resolve_group_term( term ) if
				/^#{GROUP_TERM_PATTERN}$/.match( term )

			return resolve_analyte_term( term ) if
				/^#{ANALYTE_TERM_PATTERN}$/.match( term )

				# raise error if not matched
		end

		def resolve_rule_term( term )
			rule_identifier = RULE_PATTERN.match( term )[0]
			property = RULE_PROPERTY_PATTERN.match( term )[0]

			rule = resolve_rule_identifier( rule_identifier )
			ans = method( "rule_#{property}" ).call( rule )

			@term_values[term] = ans
			return ans
		end

		def resolve_group_term( term )
			group_identifier = GROUP_PATTERN.match( term )[0]
			property =  GROUP_PROPERTY_PATTERN.match( term )[0]

			group = resolve_group_identifier( group_identifier )
			ans = method( "group_#{property}" ).call( group )

			@term_values[term] = ans
			return ans
		end

		def resolve_analyte_term( term )
			analyte_identifier = ANALYTE_PATTERN.match( term )[0]
			property = ANALYTE_PROPERTY_PATTERN.match( term )[0]

			analyte = resolve_analyte_identifier( analyte_identifier )
			ans = method( "analyte_#{property}" ).call( analyte )

			@term_values[term] = ans
			return ans
		end

		#--- Idenitifer Resolustion ---
		
		def resolve_rule_identifier( identifier )
			group_id = GROUP_PATTERN.match( identifier )[1]
			analyte_id = ANALYTE_PATTERN.match( identifier )[1]
			Rule.where analyte_group_id: group_id, analyte_id: analyte_id
		end

		def resolve_group_identifier( identifier )
			group_id = GROUP_PATTERN.match( identifier )[1]
			AnalyteGroup.find group_id
		end

		def	resolve_analyte_identifier( identifier )
			analyte_id = ANALYTE_PATTERN.match( identifier )[1]
			Analyte.find analyte_id
		end

		#--- Rule Functions ---
		
		def rule_severity( rule )
			rule_partitions = rule.partitions
			analyte_result = test.results.find_by analyte_id: rule.analyte_id
			analyte_amount = analyte_result.amount.to_f

			rule_partitions.get_amount_partition( analyte_amount ).severity
		end

		def rule_weight( rule )
			rule.weight
		end

		def rule_weighted_amount( rule )
			analyte_result = test.results.find_by analyte_id: rule.analyte_id
			analyte_amount = analyte_result.amount.to_f

			analyte_amount * rule.weight
		end

		def rule_weighted_severity( rule )
			rule.weight * rule_severity( rule )
		end

		#--- Group Functions ---
		
		def group_amount( group )
			analyte_ids = []
			group.analytes.each do |analyte|
				analyte_ids << analyte.id
			end
			
			amount = 0.0
			@test.results.each do |result|
				amount += result.amount if analyte_ids.include? result.analyte_id		
			end

			amount
		end

		def group_severity( group )
			severity = 0
			group.rules.each do |rule|
				analyte_id = rule.analyte_id
				result = @test.results.find_by analyte_id: analyte_id

				partition = rule.partitions.get_amount_partition( result.amount )
				severity += partition.severity
			end
			
			return severity
		end

		def group_weighted_amount( group )
			amount = 0.0
			group.rules.each do |rule|
				analyte_id = rule.analyte_id
				result = @test.results.find_by analyte_id: analyte_id

				amount += result.amount * rule.weight
			end

			return amount
		end

		def group_weighted_severity( group )
			severity = 0
			group.rules.each do |rule|
				analyte_id = rule.analyte_id
				result = @test.results.find_by analyte_id: analyte_id

				partition = rule.partitions.get_amount_partition( result.amount )
				severity += partition.severity * rule.weight
			end
			
			return severity
		end

		#--- Analyte Functions ---
		
		def analyte_amount( analyte ) 
			result = @test.results.find_by analyte_id: analyte.id
			result.amount.to_f
		end

		def analyte_severity( analyte )
			result = @test.results.find_by analyte_id: analyte.id
			partition = analyte.partitions.get_amount_partition result.amount
			partition.severity
		end


end # TriggerAlgebra


class TriggerAlgebraError < StandardError

end
