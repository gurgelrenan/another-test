require "csv"

class CalcValidation
	attr_accessor :entries, :rules, :result, :final

	def initialize(entries, rules)
		@entries = entries
		@rules = rules
		@result = Array.new
		@final = Array.new
	end

	def get_hash_rules
		for	i in 1...@entries.length
			for	k in 1...@rules.length
				entrie_operation = @entries[i][1]
				entrie_classification = @entries[i][2]
				rule_operation = @rules[k][1]
				rule_classification = @rules[k][2]

				if( check_entrie_operation?(entrie_operation, rule_operation) && check_entrie_classification?(entrie_classification, rule_classification)  )
					@result << {:entrie => @entries[i], :rule => @rules[k]} 
				end
			end	
		end
	end

	def check_entrie_operation?(entrie_operation, rule_operation)
		(entrie_operation == rule_operation || rule_operation == "*")
	end

	def check_entrie_classification?(entrie_classification, rule_classification)
		(entrie_classification == rule_classification || rule_classification == "*")
	end

	def calcula_imposto(valor, aliquota)
		format("%.2f", (valor * aliquota) / 100.00)
	end

	def get_final_rules
		@final << ["NUMERO", "REGRA", "CORRETO"]

		@result.each do |r|
			valor = r[:entrie][3]
			aliquota = r[:rule][3]
			valor_imposto_entrie = r[:entrie][4]
			valor_imposto_real = calcula_imposto(valor.to_i, aliquota.to_i)
			if valor_imposto_real == valor_imposto_entrie
				@final << [r[:entrie][0], r[:rule][0], "S"]
			else
				@final << [r[:entrie][0], r[:rule][0], "N"]
			end
		end
	end

	def generate_output_file
		CSV.open("saida.csv", "w") do |csv|
			@final.each do |f|
				csv << f
			end
		end
	end
end	