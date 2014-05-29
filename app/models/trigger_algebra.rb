class TriggerAlgebra
	attr_reader :test
	attr_reader :term_values

	def initialize( test )
		@test = test
		@term_values = {}
	end

	def triggered?( equation )
		if is_quantified? equation
			resolve_quantified_equation equation
		
		else
			eval resolve_equation( equation )
		
		end
	end

	def evaluate_expression( exp )
		eval resolve_expression( exp )
	end

	def results
		@test.results
	end

	# Class Method
	def self.required_analytes( exp )
		analytes = []

		# Analyte matches
		offset = 0
		while ( match = ANALYTE_PATTERN.match( exp, offset )) do
			id  = match[1].to_i
			analytes.push id unless analytes.include? id

			offset = match.end 0
		end
		
		# Groups matches
		offset = 0
		while ( match = GROUP_PATTERN.match( exp, offset )) do
			group = AnalyteGroup.find match[1]
			group.analytes.each do | analyte |
				analytes.push analyte.id unless analytes.include? analyte.id
			end

			offset = match.end 0
		end
		
		# Rule matches
		offset = 0
		while ( match = RULE_PATTERN.match( exp, offset )) do
			id = match[2].to_i
			analytes.push id unless analytes.include? id

			offset = match.end 0
		end

		return analytes
	end
	
	private
		
		EQUALITY_PATTERN = Regexp.new '>=|<=|!=|>|<|=='
	
		#--- Object Patterns ---
		ANALYTE_PATTERN = Regexp.new 'Analyte\((\d+)\)'
		GROUP_PATTERN 	= Regexp.new "Group\\((\\d+)\\)(?!\\.#{ANALYTE_PATTERN})"
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

		#--- Property Patterns ---
		ANALYTE_PROPERTY_PATTERN = Regexp.new(
			'amount|severity'
		)
		GROUP_PROPERTY_PATTERN = Regexp.new(
			'weighted_amount|weighted_severity|severities|amount|severity|weight'
		)
		RULE_PROPERTY_PATTERN = Regexp.new(
			'weighted_amount|weighted_severity|weight|severity'
		)

		#--- Term Patterns ---
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

		#--- Equation + Expression Patterns ---
		EXPRESSION_PATTERN = Regexp.new(
			"(?:#{TERM_PATTERN}|\\d|[^=<>!])+"
		)
		EQUATION_PATTERN = Regexp.new(
			"#{EXPRESSION_PATTERN}\\s?#{EQUALITY_PATTERN}\\s?#{EXPRESSION_PATTERN}"
		)

		#--- Quantifier Patterns ---
		UNQUANTIFIED_ANALYTE_PATTERN =  Regexp.new 'Analyte'
		UNQUANTIFIED_GROUP_PATTERN = Regexp.new 'Group'
		UNQUANTIFIED_RULE_PATTERN = Regexp.new 'Group\(\d+\)\.Analyte'
		UNQUANTIFIED_OBJECT_PATTERN = Regexp.new(
			"#{UNQUANTIFIED_RULE_PATTERN}|" + 
			"#{UNQUANTIFIED_ANALYTE_PATTERN}|#{UNQUANTIFIED_GROUP_PATTERN}"
		)

		IDENTIFIER_VARIABLE_PATTERN = Regexp.new( 
			"(\\w+):(#{UNQUANTIFIED_OBJECT_PATTERN})"
		)			
		THERE_EXISTS_PATTERN = Regexp.new( 
			"ThereExists\\(#{IDENTIFIER_VARIABLE_PATTERN}?" +
			"(?:\\s#{IDENTIFIER_VARIABLE_PATTERN})*\\)"
		)
		FOR_ALL_PATTERN = Regexp.new(
			"ForAll\\(#{IDENTIFIER_VARIABLE_PATTERN}?" +
			"(?:\\s#{IDENTIFIER_VARIABLE_PATTERN})*\\)"
		)
		QUANTIFIER_PATTERN = Regexp.new "#{THERE_EXISTS_PATTERN}|#{FOR_ALL_PATTERN}"
		QUANTIFIED_EXPRESSION = Regexp.new( 
			"#{QUANTIFIER_PATTERN}\\[.*\\]"
		)
		QUANTIFIED_EQUATION = Regexp.new(
			"#{QUANTIFIER_PATTERN}\\[(.*)\\]"
		)
		QUANTIFIED_STATEMENT = Regexp.new(
			"#{QUANTIFIED_EQUATION}|#{QUANTIFIED_EXPRESSION}"
		)

		#--- Quantifiers ---

		def is_quantified?( statement )
			QUANTIFIER_PATTERN.match( statement )? true : false
		end

		def resolve_quantified_equation( equation )
			resolved_equations = []
			offset = 0

			while QUANTIFIER_PATTERN.match equation, offset 
				eq_pattern = Regexp.new( "#{QUANTIFIER_PATTERN}\\[(.*)\\]" )
				quantified_statement = eq_pattern.match equation
				
				resolved_statements = build_quantified_list quantified_statement[0]
				resolved_statements.each do |statement|
					statement_start = quantified_statement.begin 0
					resolved_equation = String.new equation
					resolved_equation.slice! statement_start, quantified_statement[0].length
					resolved_equation.insert statement_start, statement

					resolved_equations << resolved_equation
				end

				offset = quantified_statement.end( 0 )
			end

			return there_exists resolved_equations if
				THERE_EXISTS_PATTERN.match equation

			return for_all resolved_equations if
				FOR_ALL_PATTERN.match equation
		end

		def build_quantified_list( statement )
			quantified_variables = []
			offset = 0
			while (match = IDENTIFIER_VARIABLE_PATTERN.match( statement, offset ))
				quantified_variables << [ match[1], match[2] ]
				offset = match.end 0
			end

			raw_statement = Regexp.new( "#{QUANTIFIER_PATTERN}\\[(.*)\\]" ).
				match( statement ).captures.last

			resolve_identifier_variables quantified_variables, [raw_statement]
		end

		def resolve_identifier_variables( variables, statements )
			# Base Case
			return statements if variables.empty?
			
			# Recursive Case
			var = variables.pop
			var_name = var[0]
			var_type = var[1]
			var_term_pattern = quantified_term_regexp var_name, var_type

			if UNQUANTIFIED_ANALYTE_PATTERN.match var_type
				objects = @test.analytes

			elsif UNQUANTIFIED_GROUP_PATTERN.match var_type
				objects = []
				AnalyteGroup.all.each do |group|
					objects << group if !( group.analytes & @test.analytes ).empty? 
				end
				
			elsif (match = UNQUANTIFIED_RULE_PATTERN.match var_type)
				objects = AnalyteGroup.find( match[1] ).rules
				
			end

			new_statements = []
			statements.each do |statement|
				objects.each do |obj|
					resolved_statement = String.new statement
					offset = 0

					while (match = var_term_pattern.match resolved_statement, offset)
						start = match.begin 0

						resolved_statement.slice! start, var_name.length
						resolved_term = var_type + "(#{obj.id})"
						resolved_statement.insert start, resolved_term

						offset = start + resolved_term.length
					end	

					new_statements	<< resolved_statement
				end
			end

			resolve_identifier_variables( variables, new_statements )
		end
	
		def quantified_term_regexp( name, type )
			case type
			when 'Analyte'
				prop_pattern = ANALYTE_PROPERTY_PATTERN
			when 'Group'
				prop_pattern = GROUP_PROPERTY_PATTERN
			when /Group\(\d+\).Analyte/
				prop_pattern = RULE_PROPERTY_PATTERN
			end

			Regexp.new "\\b#{name}\\.#{prop_pattern}\\b"
		end
			
		#--- Resolutions ---

		def there_exists( equations )
			equations.each do |eq|
					return true if triggered? eq
			end

			return false
		end

		def for_all( equations )
			equations.each do |eq|
				return false unless triggered? eq
			end

			return true
		end
		
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
			Rule.where( analyte_group_id: group_id, analyte_id: analyte_id )[0]
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
