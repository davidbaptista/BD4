/* RI 100*/

DROP trigger IF EXISTS ri_100 ON consulta;
DROP trigger IF EXISTS ri_100_ ON consulta;

CREATE OR replace FUNCTION restricao_100() RETURNS trigger AS $$
DECLARE num NUMERIC(20,0);
BEGIN
    SELECT count(1) into num FROM consulta 
	WHERE EXTRACT(WEEK FROM data_consulta)=EXTRACT(WEEK FROM new.data_consulta) 
	AND EXTRACT(YEAR FROM data_consulta)=EXTRACT(YEAR FROM new.data_consulta) 
	AND new.num_cedula=num_cedula AND new.nome_instituicao = nome_instituicao;
    IF num >= 100 THEN
		raise exception 'O medico % ja excedeu o limite de consultas por semana na instituicao %', new.num_cedula, new.nome_instituicao;
	END IF;
    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE trigger ri_100 BEFORE INSERT ON consulta 
for each ROW EXECUTE PROCEDURE restricao_100();

CREATE trigger ri_100_ BEFORE UPDATE ON consulta 
for each ROW EXECUTE PROCEDURE restricao_100();

/* RI ANALISE */

DROP trigger IF EXISTS ri_analise ON analise;

CREATE OR REPLACE FUNCTION restricao_analise() RETURNS trigger as $$
DECLARE esp VARCHAR(80);
BEGIN
	IF new.num_cedula IS NOT NULL THEN
		SELECT especialidade into esp FROM medico WHERE num_cedula = new.num_cedula;

		IF esp != new.especialidade THEN
			raise exception 'A especialidade do medico tem de ser a mesma da analise';
		END IF;
	END IF;
	RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE trigger ri_analise BEFORE INSERT ON analise 
for each ROW EXECUTE PROCEDURE restricao_analise();

CREATE trigger ri_analise_ BEFORE UPDATE ON analise 
for each ROW EXECUTE PROCEDURE restricao_analise();



