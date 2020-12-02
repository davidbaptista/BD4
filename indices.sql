/* #1 */

/* 
Optamos por criar um indice de hash com chave de pesquisa num_doente na tabela consulta, 
dado que a tabela e indexada por 3 campos diferentes, logo apesar de num_doente fazer
parte dessa chave primaria, a tabela esta indexada aos 3 campos data_consulta, num_cedula e num_doente. Por esta razao
criamos o indice index1 de modo a ser mais rapida a comparacao num_doente = <valor> 
*/

CREATE INDEX index1 ON consulta USING hash(num_doente);

/* #2 */

/* 
Optamos por criar um indice bitmap com base no atributo especialidade, dado que este apenas varia entre 6 valores e
o indice default da chave primaria (num_cedula) da tabela medico nao permite facilitar a procura por especialidade 
*/
CREATE INDEX index2 ON medico USING bitmap(especialidade); 



CREATE INDEX index2 ON medico USING hash(especialidade); /* Dado não haver bitmap no postgresql */

/* #3 */

/* 
Dividindo o numero de bytes de cada bloco pelo numero de bytes do registo, obtemos que cada bloco tem 2 registos. Como os medicos estão 
distribuidos uniformemente pelas 6 especialidades, temos a seletividade é de 1/6, logo a probabilidade de nao ter o registo desejado no bloco é de (5/6)^2 = 69,44%. 
Deste modo concluimos que teremos de ler 100% - 69,44% = 30,555% dos blocos nesta query com um indice, logo concluimos que é benefico utilizar um
indice para reduzir leituras no disco. 
Optamos então por utilizar um indice btree com chave de pesquisa especialidade na tabela btree pois utiliza um numero pequeno de niveis, 
devido a sua propriedade logaritmica.
*/
CREATE INDEX index3 ON medico USING btree(especialidade)

/* #4 */

/* 
Como num_cedula e a chave primaria da tabela apenas e necessario criar index desse campo para a tabela consulta. 
Optamos por um indice hash com a chave de pesquisa num_cedula na tabela consulta. Para facilitar a segunda parte 
do where obtamos um indice btree dado que sao feitas comparacoes de menor e maior
*/

CREATE INDEX index4 ON consulta USING hash(num_cedula);
CREATE INDEX index5 ON consulta USING btree(data_consulta);
/* */

