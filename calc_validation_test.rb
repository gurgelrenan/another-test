require "./calc_validation"
require "test/unit"

class TestCalcValidation < Test::Unit::TestCase
	def setup
		@entries = CSV.read('entries.csv')
		@rules = CSV.read('rules.csv')
	end

	def test_initialize
		assert_raise(ArgumentError){CalcValidation.new}
		assert_raise(ArgumentError){CalcValidation.new(@entries)}
	end

	def test_get_hash_rules
		calc = CalcValidation.new(@entries, @rules)
		result = calc.get_hash_rules
		assert_equal([
			{:entrie=>["001", "VENDA", "A", "1000.00", "180.00"], :rule=>["1", "VENDA", "A", "18.00"]},
			{:entrie=>["002", "TRANSFERENCIA", "A", "2000.00", "360.00"], :rule=>["4", "TRANSFERENCIA", "*", "15.00"]},
			{:entrie=>["003", "DOACAO", "B", "500.00", "0.00"], :rule=>["5", "DOACAO", "*", "0.00"]},
			{:entrie=>["004", "VENDA", "B", "314.15", "31.42"], :rule=>["2", "VENDA", "B", "10.00"]},
			{:entrie=>["005", "VENDA", "A", "1200.98", "216.18"], :rule=>["1", "VENDA", "A", "18.00"]}], result)
	end
end
