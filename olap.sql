 
SELECT a.especialidade, dt.ano, dt.mes, count(fa.id_analise) AS total
FROM f_analise fa
JOIN d_tempo dt ON dt.id_tempo = fa.id_data_registo
JOIN analise a ON fa.id_analise = a.num_analise
WHERE dt.ano BETWEEN 2017 AND 2020 AND a.nome = 'glicemia'
GROUP BY
GROUPING SETS((a.especialidade, ano, mes), (a.especialidade, ano))
ORDER BY ano, mes;


SELECT v.substancia, c.nome, dt.ano,dt.mes, dt.semana, (count(fp.id_presc_venda) / count(distinct fp.id_presc_venda)) AS media, sum(v.quant) AS total
FROM f_presc_venda fp
JOIN venda_farmacia v ON v.num_venda = fp.id_presc_venda
JOIN d_instituicao i ON i.id_inst = fp.id_inst
JOIN regiao r ON r.num_regiao = i.num_regiao
JOIN concelho c ON c.num_concelho = i.num_concelho
JOIN d_tempo dt ON dt.id_tempo = fp.id_data_registo
WHERE dt.ano = 2020 AND dt.trimestre = 1 AND r.nome = 'Lisboa'
GROUP BY GROUPING SETS ((v.substancia,dt.ano,dt.mes,dt.semana),(v.substancia,dt.ano,dt.mes),(v.substancia,dt.ano), (v.substancia,c.nome, dt.ano,dt.mes,dt.semana), (v.substancia,c.nome, dt.ano,dt.mes),(v.substancia,c.nome, dt.ano),(v.substancia,c.nome));

/*
CREATE VIEW new_view AS
(SELECT v.substancia, c.nome, dt.ano, dt.mes, dt.semana, avg(fp.id_presc_venda) AS media, sum(v.quant) AS total
FROM f_presc_venda fp
JOIN venda_farmacia v ON v.num_venda = fp.id_presc_venda
JOIN d_instituicao i ON i.id_inst = fp.id_inst
JOIN regiao r ON r.num_regiao = i.num_regiao
JOIN concelho c ON c.num_concelho = i.num_concelho
JOIN d_tempo dt ON dt.id_tempo = fp.id_data_registo
WHERE dt.ano = 2020 AND dt.trimestre = 1 AND r.nome = 'Lisboa'
GROUP BY (v.substancia));
(SELECT * FROM new_view 
GROUP BY ROLLUP (dt.ano,dt.mes,dt.semana))
UNION
(SELECT * FROM new_view 
GROUP BY ROLLUP (c.nome, dt.ano,dt.mes,dt.semana));



CREATE VIEW new_view AS
(SELECT v.substancia, c.nome, dt.ano, dt.mes, dt.semana, fp.id_presc_venda, v.quant
FROM f_presc_venda fp
JOIN venda_farmacia v ON v.num_venda = fp.id_presc_venda
JOIN d_instituicao i ON i.id_inst = fp.id_inst
JOIN regiao r ON r.num_regiao = i.num_regiao
JOIN concelho c ON c.num_concelho = i.num_concelho
JOIN d_tempo dt ON dt.id_tempo = fp.id_data_registo
WHERE dt.ano = 2020 AND dt.trimestre = 1 AND r.nome = 'Lisboa');
(SELECT substancia,ano, mes, semana, avg(id_presc_venda) AS media, sum(quant) AS total
FROM new_view 
GROUP BY ROLLUP (substancia,ano,mes,semana))
UNION
(SELECT substancia, nome, ano, mes, semana, avg(id_presc_venda) AS media, sum(quant) AS total
FROM new_view 
GROUP BY ROLLUP (substancia, nome, ano, mes,semana));
*/

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

SELECT substancia, nome concelho, mes, semana, sum(total) AS total, avg(numero_de_vendas) AS media_diaria
FROM new_view 
GROUP BY
substancia,
ROLLUP(mes, semana),
ROLLUP(nome);
