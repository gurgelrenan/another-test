another-test
============

Another Test uma aplicação simples que faz uma validação de arquivos para verificar se estão fazendo o cálculo do 
imposto de forma correta

## Dependências

* Ruby 1.9.3 ou superior


## Como usar?

O principal arquivo ` main.rb ` contém todas as principais ações para que tenhamos o resultado esperado.
Podemos resumir o uso da seguinte maneira: 

* Carregar 2 aquivos para serem as entradas e as regras respectivamente
```ruby
	require "./calc_validation"

	entries = CSV.read('entries.csv')
	rules = CSV.read('rules.csv')
```

* Chamar método `get_hash_rules` que faz a criação de um array (result) com as nossas regras obedecidas.
```ruby
	calc.get_hash_rules
```
* Após isso basta que chamemos o método `get_final_rules` para fazer a checagem dos valores do imposto e 
já preparar o novo array (final) para ser impresso no arquivo de saida.
```ruby
	calc.get_final_rules
```

* Finalmente chamamos o método `generate_output_file` para gerar nosso arquivo de saida formatado do jeito que foi pedido.
```ruby
	calc.generate_output_file
```

## Testes

Os testes se encontram no arquivo `calc_validation_test.rb` e foram feitos com Test::Unit nativo do Ruby e podem ser verificados rodando o comando ``` ruby calc_validation.test.rb ```