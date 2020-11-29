/* #1 */

/* Optamos por criar um indice de hash dado que a tabela e indexada por 3 campos diferentes, logo apesar de num_doente fazer
parte dessa chave primaria, a tabela esta indexada aos 3 campos data_consulta, num_cedula e num_doente. Por esta razao
criamos o indice index1 de modo a ser mais rapida a comparacao num_doente = <valor> */

CREATE INDEX index1 ON consulta USING hash(num_doente);

/* #2 */

/* Optamos por criar um indice bitmap com base no atributo especialidade, dado que este apenas varia entre 6 valores 
a chave primaria (num_cedula) da tabela medico nao permite facilitar a procura por especialidade */

CREATE INDEX index2 ON medico USING bitmap(especialidade)



/* #3 */

/* Dividindo o numero de bytes de cada bloco pelo numero de bytes do registo, obtemos que cada bloco tem 2 registos. Como os medicos estão 
distribuidos uniformemente pelas 6 especialidades, temos a seletividade é de 1/6, logo a probabilidade de não ter o registo desejado no bloco é de (5/6)^2 = 69,44%. 
Deste mode concluimos que teremos de ler 100% - 69,44% = 30,555% dos blocos nesta querie com um indice, logo concluimos que é benefico utilizar um
 indice para reduzir leituras no disco */
CREATE INDEX index3 ON medico USING BTREE(especialidade)



/* #4 */

/* */

