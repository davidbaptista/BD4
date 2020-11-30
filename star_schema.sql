drop table if exists d_tempo cascade; 
drop table if exists d_instituicao cascade; 
drop table if exists f_presc_venda cascade; 
drop table if exists f_analise cascade;

create table d_tempo
(
	id_tempo SERIAL NOT NULL,
	dia NUMERIC(2,0) NOT NULL,
	dia_da_semana NUMERIC(1,0) NOT NULL,
	semana NUMERIC(2, 0) NOT NULL,
	mes NUMERIC(2,0) NOT NULL,
	trimestre NUMERIC(1,0) NOT NULL,
	ano NUMERIC(4,0) NOT NULL,
	CONSTRAINT pk_id_tempo PRIMARY KEY (id_tempo)
);

create table d_instituicao
(
	id_inst SERIAL NOT NULL,
	nome VARCHAR(80) NOT NULL,
	tipo VARCHAR(80) NOT NULL,
	num_regiao NUMERIC(1, 0),
	num_concelho NUMERIC(10, 0),

	CONSTRAINT pk_id_inst PRIMARY KEY (id_inst),
	CONSTRAINT fk_nome_instituicao FOREIGN KEY(nome) REFERENCES instituicao(nome) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_num_regiao FOREIGN KEY (num_regiao) REFERENCES regiao(num_regiao) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_num_concelho FOREIGN KEY (num_concelho) REFERENCES concelho(num_concelho) ON UPDATE CASCADE ON DELETE CASCADE
);

create table f_presc_venda(
	id_presc_venda NUMERIC(10,0) NOT NULL,
	id_medico NUMERIC(10, 0) NOT NULL,
	id_data_registo integer NOT NULL,
	id_inst integer NOT NULL,
	CONSTRAINT pk_id_presc_venda PRIMARY KEY (id_presc_venda),
	CONSTRAINT fk_id_presc_venda FOREIGN KEY (id_presc_venda) REFERENCES prescricao_venda(num_venda) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_id_medico FOREIGN KEY (id_medico) REFERENCES medico(num_cedula) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_id_data_registo FOREIGN KEY (id_data_registo) REFERENCES d_tempo(id_tempo) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_id_inst FOREIGN KEY (id_inst) REFERENCES d_instituicao(id_inst)  ON UPDATE CASCADE ON DELETE CASCADE
	 
);

create table f_analise(
    id_analise NUMERIC(10, 0) NOT NULL,
    id_medico integer NOT NULL,
    id_data_registo INTEGER NOT NULL,
    id_inst INTEGER NOT NULL,
    CONSTRAINT pk_id_analise PRIMARY KEY (id_analise),
    CONSTRAINT fk_id_analise FOREIGN KEY (id_analise) REFERENCES analise(num_analise) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_id_medico FOREIGN KEY (id_medico) REFERENCES medico (num_cedula) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_id_data_registo FOREIGN KEY(id_data_registo) REFERENCES d_tempo(id_tempo) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_id_inst FOREIGN KEY(id_inst) REFERENCES d_instituicao(id_inst) ON UPDATE CASCADE ON DELETE CASCADE

);

