INSERT INTO d_tempo(dia, dia_da_semana, semana, mes, trimestre, ano) 
	SELECT DISTINCT * FROM (SELECT EXTRACT(day from data_registo) dia,
    		EXTRACT(DOW from data_registo) dia_da_semana,
            EXTRACT(week from data_registo) semana,
            EXTRACT(month from data_registo) mes,
            EXTRACT(quarter from data_registo) trimestre,
            EXTRACT(year from data_registo) ano FROM analise

			UNION 
			
			SELECT EXTRACT(day from data_registo) dia,
    		EXTRACT(DOW from data_registo) dia_da_semana,
            EXTRACT(week from data_registo) semana,
            EXTRACT(month from data_registo) mes,
            EXTRACT(quarter from data_registo) trimestre,
            EXTRACT(year from data_registo) ano FROM venda_farmacia) as result;


INSERT INTO d_instituicao(nome,tipo, num_regiao,num_concelho) 
    SELECT nome, tipo, num_regiao, num_concelho
    FROM instituicao;

INSERT INTO f_presc_venda(id_presc_venda, id_medico, id_data_registo, id_inst)
    SELECT id_presc_venda, id_medico, id_data_registo, inst FROM prescricao_venda NATURAL JOIN venda_farmacia;
    

INSERT INTO f_analise(id_analise, id_medico, id_data_registo, id_inst)
    SELECT a.num_analise, m.num_cedula, id_tempo, id_inst
    FROM analise a
    JOIN d_tempo dt ON EXTRACT(day from a.data_registo) = dt.dia AND EXTRACT(week from a.data_registo) = dt.semana AND EXTRACT(year from a.data_registo) = dt.ano
    JOIN medico m ON m.num_cedula = a.num_cedula
    JOIN d_instituicao i ON a.inst = i.nome ;
