require "./calc_validation"
require "test/unit"

class TestCalcValidation < Test::Unit::TestCase
	def setup
		@entries = CSV.read('entries.csv')
		@rules = CSV.read('rules.csv')
		@calc = CalcValidation.new(@entries, @rules)
	end

	def test_initialize
		assert_raise(ArgumentError){CalcValidation.new}
		assert_raise(ArgumentError){CalcValidation.new(@entries)}
	end

	def test_get_hash_rules
		result = @calc.get_hash_rules
		assert_equal([
			{:entrie=>["001", "VENDA", "A", "1000.00", "180.00"], :rule=>["1", "VENDA", "A", "18.00"]},
			{:entrie=>["002", "TRANSFERENCIA", "A", "2000.00", "360.00"], :rule=>["4", "TRANSFERENCIA", "*", "15.00"]},
			{:entrie=>["003", "DOACAO", "B", "500.00", "0.00"], :rule=>["5", "DOACAO", "*", "0.00"]},
			{:entrie=>["004", "VENDA", "B", "314.15", "31.42"], :rule=>["2", "VENDA", "B", "10.00"]},
			{:entrie=>["005", "VENDA", "A", "1200.98", "216.18"], :rule=>["1", "VENDA", "A", "18.00"]}], result)
	end

	def test_check_entrie_operation?
		assert_equal(@calc.check_entrie_operation?("VENDA", "VENDA"), true)
		assert_equal(@calc.check_entrie_operation?("VENDA", "TRANSFERENCIA"), false)
		assert_equal(@calc.check_entrie_operation?("VENDA", "DOACAO"), false)
		assert_equal(@calc.check_entrie_operation?("VENDA", "*"), true)

		assert_equal(@calc.check_entrie_operation?("TRANSFERENCIA", "VENDA"), false)
		assert_equal(@calc.check_entrie_operation?("TRANSFERENCIA", "TRANSFERENCIA"), true)
		assert_equal(@calc.check_entrie_operation?("TRANSFERENCIA", "DOACAO"), false)
		assert_equal(@calc.check_entrie_operation?("TRANSFERENCIA", "*"), true)

		assert_equal(@calc.check_entrie_operation?("DOACAO", "VENDA"), false)
		assert_equal(@calc.check_entrie_operation?("DOACAO", "TRANSFERENCIA"), false)
		assert_equal(@calc.check_entrie_operation?("DOACAO", "DOACAO"), true)
		assert_equal(@calc.check_entrie_operation?("DOACAO", "*"), true)
	end

	def test_check_entrie_classification?
		assert_equal(@calc.check_entrie_operation?("A", "A"), true)
		assert_equal(@calc.check_entrie_operation?("A", "B"), false)
		assert_equal(@calc.check_entrie_operation?("A", "C"), false)
		assert_equal(@calc.check_entrie_operation?("A", "*"), true)

		assert_equal(@calc.check_entrie_operation?("B", "A"), false)
		assert_equal(@calc.check_entrie_operation?("B", "B"), true)
		assert_equal(@calc.check_entrie_operation?("B", "C"), false)
		assert_equal(@calc.check_entrie_operation?("B", "*"), true)

		assert_equal(@calc.check_entrie_operation?("C", "A"), false)
		assert_equal(@calc.check_entrie_operation?("C", "B"), false)
		assert_equal(@calc.check_entrie_operation?("C", "C"), true)
		assert_equal(@calc.check_entrie_operation?("C", "*"), true)		
	end

	def test_calcula_imposto
		assert_equal(@calc.calcula_imposto(1000, 18), "180.00")
	end

	def test_get_final_rules
		@calc.get_hash_rules
		final_result = @calc.get_final_rules
		assert_equal(final_result, [["NUMERO", "REGRA", "CORRETO"], ["001", "1", "S"], ["002", "4", "N"], ["003", "5", "S"], ["004", "2", "N"], ["005", "1", "N"]])
	end

	def test_generate_output_file
		@calc.get_hash_rules
		@calc.get_final_rules
		@calc.generate_output_file
		
		assert_equal(File.exist?("saida.csv"), true)
	end
end
