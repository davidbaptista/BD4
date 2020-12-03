 
SELECT a.especialidade, dt.ano, dt.mes, count(fa.id_analise) AS total
FROM f_analise fa
JOIN d_tempo dt ON dt.id_tempo = fa.id_data_registo
JOIN analise a ON fa.id_analise = a.num_analise
WHERE dt.ano BETWEEN 2017 AND 2020 AND a.nome = 'glicemia'
GROUP BY
GROUPING SETS((a.especialidade, ano, mes), (a.especialidade, ano))
ORDER BY ano, mes;




CREATE VIEW new_view AS
(SELECT v.substancia, c.nome, dt.mes, dt.semana, dt.dia_da_semana, sum(v.quant) total, count(1) numero_de_vendas
FROM f_presc_venda fp
JOIN venda_farmacia v ON v.num_venda = fp.id_presc_venda
JOIN d_instituicao i ON i.id_inst = fp.id_inst
JOIN regiao r ON r.num_regiao = i.num_regiao
JOIN concelho c ON c.num_concelho = i.num_concelho
JOIN d_tempo dt ON dt.id_tempo = fp.id_data_registo
WHERE dt.ano = 2020 AND dt.trimestre = 1 AND r.nome = 'Lisboa'
GROUP BY v.substancia, c.nome, dt.mes, dt.semana, dt.dia_da_semana);

/* Como não temos registos para todos os dias da semana e todos os meses, a função avg() não irá devolver a média diária exata */

SELECT substancia, nome concelho, mes, dia_da_semana, sum(total) AS total, avg(numero_de_vendas) AS media
FROM new_view 
GROUP BY
substancia,
ROLLUP(mes, dia_da_semana),
ROLLUP(nome);
