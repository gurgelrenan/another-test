require "./calc_validation"

entries = CSV.read('entries.csv')
rules = CSV.read('rules.csv')

calc = CalcValidation.new(entries, rules)

calc.get_hash_rules

calc.get_final_rules

calc.generate_output_file
