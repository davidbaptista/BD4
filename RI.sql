
DROP trigger IF EXISTS ri_100 ON consulta;

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







