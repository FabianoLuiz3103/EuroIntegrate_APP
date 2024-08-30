-- 12345678
INSERT INTO usuarios (email, senha) VALUES ('fabianojesus1991@gmail.com', '$2a$12$.bPF9WkGJjzfKsxe10UhFeu5wyPj8LYVKVKm7ZRv6jjC.zkkAHg5W');
-- 310331
INSERT INTO usuarios (email, senha) VALUES ('faah772@gmail.com', '$2a$12$K8vGtJq3q4fz7BRRXSOg/u.txCUIv3pXE1LBsJZPWoeFLhXs9mUDS');
-- 121212
INSERT INTO usuarios (email, senha) VALUES ('larissa1.almeida@example.com', '$2a$12$svsF9WZ5UKHoRTKb69FbnOpKntgOni41W6F2C.1acvJ9ur3HYJR66');

INSERT INTO roles (name) VALUES ('ROLE_ADMINISTRATOR');
INSERT INTO roles (name) VALUES ('ROLE_CUSTOMER');


INSERT INTO users_roles (role_id, user_id) VALUES (2,1);
INSERT INTO users_roles (role_id, user_id) VALUES (1,2);
INSERT INTO users_roles (role_id, user_id) VALUES (2,3);

INSERT INTO tbl_departamento (nome) VALUES ('Tecnologia da Informação (TI)');
INSERT INTO tbl_departamento (nome) VALUES ('Financeiro');
INSERT INTO tbl_departamento (nome) VALUES ('Marketing');
INSERT INTO tbl_departamento (nome) VALUES ('Jurídico');
INSERT INTO tbl_departamento (nome) VALUES ('Recursos Humanos (RH)');


INSERT INTO tbl_colaborador (primeiro_nome, sobrenome, cpf, email, telefone, data_admissao, avatar, sts_integracao, qtd_respondidas, pontuacao, qtd_certas, porc_progresso, porc_acertos, numero_matricula, data_nascimento, id_departamento) VALUES ('João', 'Silva', '123.456.719-00', 'fabianojesus1991@gmail.com', '123456789', '2024-06-18', 'avatar1.png', 'NAO_FEZ', 0, 0, 0, 0.0, 0.0, '96044', '2000-03-12', 3);
INSERT INTO tbl_colaborador (primeiro_nome, sobrenome, cpf, email, telefone, data_admissao, avatar, sts_integracao, qtd_respondidas, pontuacao, qtd_certas, porc_progresso, porc_acertos, numero_matricula, data_nascimento, id_departamento) VALUES ('Maria', 'Santos', '997.654.321-00', 'maria.santos@example.com', '987654321', '2024-06-19', 'avatar2.png', 'NAO_FEZ', 0, 0, 0, 0.0, 0.0, '96055', '1990-05-12', 3);
INSERT INTO tbl_colaborador (primeiro_nome, sobrenome, cpf, email, telefone, data_admissao, avatar, sts_integracao, qtd_respondidas, pontuacao, qtd_certas, porc_progresso, porc_acertos, numero_matricula, data_nascimento, id_departamento) VALUES ('Carlos', 'Oliveira', '234.567.890-11', 'carlos.oliveira@example.com', '234567890', '2024-06-20', 'avatar3.png', 'NAO_FEZ', 0, 0, 0, 0.0, 0.0, '97044', '2003-03-31',3);
INSERT INTO tbl_colaborador (primeiro_nome, sobrenome, cpf, email, telefone, data_admissao, avatar, sts_integracao, qtd_respondidas, pontuacao, qtd_certas, porc_progresso, porc_acertos, numero_matricula, data_nascimento, id_departamento) VALUES ('Ana', 'Pereira', '345.678.901-22', 'ana.pereira@example.com', '345678901', '2024-06-21', 'avatar4.png', 'NAO_FEZ', 0, 0, 0, 0.0, 0.0, '98844', '2000-03-03',3);
INSERT INTO tbl_colaborador (primeiro_nome, sobrenome, cpf, email, telefone, data_admissao, avatar, sts_integracao, qtd_respondidas, pontuacao, qtd_certas, porc_progresso, porc_acertos, numero_matricula, data_nascimento, id_departamento) VALUES ('Pedro', 'Rodrigues', '456.789.012-33', 'pedro.rodrigues@example.com', '456789012', '2024-06-22', 'avatar5.png', 'NAO_FEZ', 0, 0, 0, 0.0, 0.0, '96994', '1988-12-19',3);
INSERT INTO tbl_colaborador (primeiro_nome, sobrenome, cpf, email, telefone, data_admissao, avatar, sts_integracao, qtd_respondidas, pontuacao, qtd_certas, porc_progresso, porc_acertos, numero_matricula, data_nascimento, id_departamento) VALUES ('Juliana', 'Ferreira', '567.890.123-44', 'juliana.ferreira@example.com', '567890123', '2024-06-23', 'avatar6.png', 'NAO_FEZ', 0, 0, 0, 0.0, 0.0, '99944', '1975-03-20',3);
INSERT INTO tbl_colaborador (primeiro_nome, sobrenome, cpf, email, telefone, data_admissao, avatar, sts_integracao, qtd_respondidas, pontuacao, qtd_certas, porc_progresso, porc_acertos, numero_matricula, data_nascimento, id_departamento) VALUES ('Fernando', 'Gomes', '678.901.234-55', 'fernando.gomes@example.com', '678901234', '2024-06-24', 'avatar7.png', 'NAO_FEZ', 0, 0, 0, 0.0, 0.0, '96119', '1950-03-09',3);



INSERT INTO tbl_colaborador (primeiro_nome, sobrenome, cpf, email, telefone, data_admissao, avatar, sts_integracao, qtd_respondidas, pontuacao, qtd_certas, porc_progresso, porc_acertos, numero_matricula, data_nascimento, id_departamento) VALUES ('Fabiano', 'L.S.S', '122.433.789-11', 'fabiano331@gmail.com', '123456889', '2024-06-18', 'avatar200.png', 'FINALIZADO', 50, 80, 40, 75.0, 50.0, '77044', '2003-03-31', 5);
INSERT INTO tbl_colaborador_rh (email_rh, id_colaborador) VALUES ('faah772@gmail.com', 8);

INSERT INTO tbl_videos(link_video, id_departamento) VALUES ('https://video1.marketing', 3);
INSERT INTO tbl_videos(link_video, id_departamento) VALUES ('https://video2.marketing', 3);
INSERT INTO tbl_videos(link_video, id_departamento) VALUES ('https://video3.marketing', 3);
INSERT INTO tbl_videos(link_video, id_departamento) VALUES ('https://video4.marketing', 3);
INSERT INTO tbl_videos(link_video, id_departamento) VALUES ('https://video1.ti', 1);

INSERT INTO tbl_videos(link_video, id_departamento) VALUES ('https://cs210032001e507a429.blob.core.windows.net/videos/videoUm_financas.mp4', 2);
INSERT INTO tbl_videos(link_video, id_departamento) VALUES ('https://cs210032001e507a429.blob.core.windows.net/videos/videoDois_financas.mp4', 2);
INSERT INTO tbl_videos(link_video, id_departamento) VALUES ('https://cs210032001e507a429.blob.core.windows.net/videos/videoTres_financas.mp4', 2);


INSERT INTO tbl_perguntas (enunciado, resposta_correta, tipo, id_video) VALUES ('Pergunta 1 do vídeo 1 de financas', 'A', 'V', 6);
INSERT INTO tbl_perguntas (enunciado, resposta_correta, tipo, id_video) VALUES ('Pergunta 2 do vídeo 1 de financas', 'B', 'V', 6);
INSERT INTO tbl_perguntas (enunciado, resposta_correta, tipo, id_video) VALUES ('Pergunta 3 do vídeo 1 de financas', 'C', 'V', 6);

INSERT INTO tbl_perguntas (enunciado, resposta_correta, tipo, id_video) VALUES ('Pergunta 1 do vídeo 2 de financas', 'D', 'V', 7);
INSERT INTO tbl_perguntas (enunciado, resposta_correta, tipo, id_video) VALUES ('Pergunta 2 do vídeo 2 de financas', 'C', 'V', 7);
INSERT INTO tbl_perguntas (enunciado, resposta_correta, tipo, id_video) VALUES ('Pergunta 3 do vídeo 2 de financas', 'B', 'V', 7);

INSERT INTO tbl_perguntas (enunciado, resposta_correta, tipo, id_video) VALUES ('Pergunta 1 do vídeo 3 de financas', 'A', 'V', 8);
INSERT INTO tbl_perguntas (enunciado, resposta_correta, tipo, id_video) VALUES ('Pergunta 2 do vídeo 3 de financas', 'B', 'V', 8);
INSERT INTO tbl_perguntas (enunciado, resposta_correta, tipo, id_video) VALUES ('Pergunta 3 do vídeo 3 de financas', 'C', 'V', 8);


INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('A', 'Texto da opcao A', 1);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('B', 'Texto da opcao B', 1);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('C', 'Texto da opcao C', 1);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('D', 'Texto da opcao D', 1);

INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('A', 'Texto da opcao A', 2);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('B', 'Texto da opcao B', 2);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('C', 'Texto da opcao C', 2);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('D', 'Texto da opcao D', 2);

INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('A', 'Texto da opcao A', 3);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('B', 'Texto da opcao B', 3);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('C', 'Texto da opcao C', 3);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('D', 'Texto da opcao D', 3);

INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('A', 'Texto da opcao A', 4);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('B', 'Texto da opcao B', 4);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('C', 'Texto da opcao C', 4);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('D', 'Texto da opcao D', 4);

INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('A', 'Texto da opcao A', 5);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('B', 'Texto da opcao B', 5);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('C', 'Texto da opcao C', 5);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('D', 'Texto da opcao D', 5);

INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('A', 'Texto da opcao A', 6);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('B', 'Texto da opcao B', 6);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('C', 'Texto da opcao C', 6);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('D', 'Texto da opcao D', 6);

INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('A', 'Texto da opcao A', 7);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('B', 'Texto da opcao B', 7);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('C', 'Texto da opcao C', 7);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('D', 'Texto da opcao D', 7);

INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('A', 'Texto da opcao A', 8);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('B', 'Texto da opcao B', 8);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('C', 'Texto da opcao C', 8);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('D', 'Texto da opcao D', 8);

INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('A', 'Texto da opcao A', 9);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('B', 'Texto da opcao B', 9);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('C', 'Texto da opcao C', 9);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('D', 'Texto da opcao D', 9);


INSERT INTO tbl_respostas(colaborador_id, pergunta_id, resposta, foi_respondida, data_resposta) VALUES (9, 1, 'A', true, sysdate);
INSERT INTO tbl_respostas(colaborador_id, pergunta_id, resposta, foi_respondida, data_resposta) VALUES (9, 2, 'C', true, sysdate);
INSERT INTO tbl_respostas(colaborador_id, pergunta_id, resposta, foi_respondida, data_resposta) VALUES (9, 3, 'C', true, sysdate);


INSERT INTO tbl_normas (nome, descricao, id_departamento) VALUES ('Norma-1-Marketing', 'Essa é descrição da Norma-1-Marketing', 3);
INSERT INTO tbl_normas (nome, descricao, id_departamento) VALUES ('Norma-2-Marketing', 'Essa é descrição da Norma-2-Marketing', 3);
INSERT INTO tbl_normas (nome, descricao, id_departamento) VALUES ('Norma-3-Marketing', 'Essa é descrição da Norma-3-Marketing', 3);
INSERT INTO tbl_normas (nome, descricao, id_departamento) VALUES ('Norma-4-Marketing', 'Essa é descrição da Norma-4-Marketing', 3);
INSERT INTO tbl_normas (nome, descricao, id_departamento) VALUES ('Norma-5-Marketing', 'Essa é descrição da Norma-5-Marketing', 3);
INSERT INTO tbl_normas (nome, descricao) VALUES ('Norma-1-Geral', 'Essa é descrição da Norma-1-Geral');
INSERT INTO tbl_normas (nome, descricao) VALUES ('Norma-2-Geral', 'Essa é descrição da Norma-1-Geral');
INSERT INTO tbl_normas (nome, descricao) VALUES ('Norma-3-Geral', 'Essa é descrição da Norma-1-Geral');
INSERT INTO tbl_normas (nome, descricao) VALUES ('Norma-4-Geral', 'Essa é descrição da Norma-1-Geral');
INSERT INTO tbl_normas (nome, descricao) VALUES ('Norma-5-Geral', 'Essa é descrição da Norma-1-Geral');

INSERT INTO tbl_perguntas (enunciado, resposta_correta, tipo, id_norma) VALUES ('Pergunta 1 da norma MKT 1', 'Resposta certa P1N1', 'N', 1);
INSERT INTO tbl_perguntas (enunciado, resposta_correta, tipo, id_norma) VALUES ('Pergunta 2 da norma MKT 1', 'Resposta certa P2N1', 'N', 1);
INSERT INTO tbl_perguntas (enunciado, resposta_correta, tipo, id_norma) VALUES ('Pergunta 3 do norma MKT 1', 'Resposta certa P3N1', 'N', 1);

INSERT INTO tbl_perguntas (enunciado, resposta_correta, tipo, id_norma) VALUES ('Pergunta 1 da norma MKT 5', 'Resposta certa P1N5', 'N', 5);
INSERT INTO tbl_perguntas (enunciado, resposta_correta, tipo, id_norma) VALUES ('Pergunta 2 da norma MKT 5', 'Resposta certa P2N5', 'N', 5);
INSERT INTO tbl_perguntas (enunciado, resposta_correta, tipo, id_norma) VALUES ('Pergunta 3 do norma MKT 5', 'Resposta certa P3N5', 'N', 5);

INSERT INTO tbl_perguntas (enunciado, resposta_correta, tipo, id_norma) VALUES ('Pergunta 1 da norma GERAL 1', 'Resposta certa P1NG1', 'N', 6);
INSERT INTO tbl_perguntas (enunciado, resposta_correta, tipo, id_norma) VALUES ('Pergunta 2 da norma GERAL 1', 'Resposta certa P2NG1', 'N', 6);
INSERT INTO tbl_perguntas (enunciado, resposta_correta, tipo, id_norma) VALUES ('Pergunta 3 do norma GERAL 1', 'Resposta certa P3NG1', 'N', 6);

INSERT INTO tbl_perguntas (enunciado, resposta_correta, tipo, id_norma) VALUES ('Pergunta 1 da norma GERAL 5', 'Resposta certa P1NG5', 'N', 10);
INSERT INTO tbl_perguntas (enunciado, resposta_correta, tipo, id_norma) VALUES ('Pergunta 2 da norma GERAL 5', 'Resposta certa P2NG5', 'N', 10);
INSERT INTO tbl_perguntas (enunciado, resposta_correta, tipo, id_norma) VALUES ('Pergunta 3 do norma GERAL 5', 'Resposta certa P3NG5', 'N', 10);

INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('A', 'Texto da opcao A', 10);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('B', 'Texto da opcao B', 10);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('C', 'Texto da opcao C', 10);
INSERT INTO tbl_opcoes (opcao, texto, id_pergunta) VALUES ('D', 'Texto da opcao D', 10);

INSERT INTO tbl_integracao (data_inicio, hora_inicio, data_fim, hora_fim, status, qtd_colaboradores, media_progresso, media_acertos, id_rh, id_departamento) VALUES ('2024-05-25', '08:30', '2024-05-30', '17:30', 'FINALIZADO', 8, 40.0, 65.0, 1, 2);

INSERT INTO tbl_colaborador (primeiro_nome, sobrenome, cpf, email, telefone, data_admissao, avatar, sts_integracao, qtd_respondidas, pontuacao, qtd_certas, porc_progresso, numero_matricula, data_nascimento, porc_acertos, id_departamento, id_integracao) VALUES ('Larissa', 'Almeida', '789.092.345-66', 'larissa1.almeida@example.com', '789012349', '2024-06-25', '{"HairStyle":"Bald","HairColor":"Auburn","FacialHairType":"Nothing","FacialHairColor":"Auburn","EyeType":"Close","EyebrowType":"Angry","Nose":"Default","MouthType":"Concerned","SkinColor":"Tanned","OutfitType":"BlazerTShirt","OutfitColor":"Black","Accessory":"Nothing","Background":"Transparent"}', 'FINALIZADO', 10, 78, 6, 45.2, '23179', '1970-08-08', 72.5, 2, 1);
INSERT INTO tbl_colaborador (primeiro_nome, sobrenome, cpf, email, telefone, data_admissao, avatar, sts_integracao, qtd_respondidas, pontuacao, qtd_certas, porc_progresso, numero_matricula, data_nascimento, porc_acertos, id_departamento, id_integracao) VALUES ('João', 'Silva', '123.496.789-00', 'joao1.silva@example.com', '987654329', '2024-06-25', 'avatar2.png', 'FINALIZADO', 5, 36, 3, 27.8, '33179', '1969-08-08',  60.0, 2, 1);
INSERT INTO tbl_colaborador (primeiro_nome, sobrenome, cpf, email, telefone, data_admissao, avatar, sts_integracao, qtd_respondidas, pontuacao, qtd_certas, porc_progresso, numero_matricula, data_nascimento, porc_acertos, id_departamento, id_integracao) VALUES ('Maria', 'Santos', '987.694.321-00', 'maria1.santos@example.com', '654987329', '2024-06-25', 'avatar3.png', 'FINALIZADO', 8, 60, 5, 36.7, '55178', '2000-10-20',  68.3, 2, 1);
INSERT INTO tbl_colaborador (primeiro_nome, sobrenome, cpf, email, telefone, data_admissao, avatar, sts_integracao, qtd_respondidas, pontuacao, qtd_certas, porc_progresso, numero_matricula, data_nascimento, porc_acertos, id_departamento, id_integracao) VALUES ('Pedro', 'Oliveira', '456.799.123-00', 'pedro1.oliveira@example.com', '321654989', '2024-06-25', 'avatar4.png', 'FINALIZADO', 12, 92, 9, 54.1, '22220', '1999-10-25',  78.9, 2, 1);
INSERT INTO tbl_colaborador (primeiro_nome, sobrenome, cpf, email, telefone, data_admissao, avatar, sts_integracao, qtd_respondidas, pontuacao, qtd_certas, porc_progresso, numero_matricula, data_nascimento, porc_acertos, id_departamento, id_integracao) VALUES ('Ana', 'Rodrigues', '654.391.987-00', 'ana1.rodrigues@example.com', '456123799', '2024-06-25', 'avatar5.png', 'FINALIZADO', 15, 110, 12, 63.5, '23679', '1975-02-20',  82.5, 2, 1);
INSERT INTO tbl_colaborador (primeiro_nome, sobrenome, cpf, email, telefone, data_admissao, avatar, sts_integracao, qtd_respondidas, pontuacao, qtd_certas, porc_progresso, numero_matricula, data_nascimento, porc_acertos, id_departamento, id_integracao) VALUES ('Carlos', 'Ferreira', '789.193.456-00', 'carlos1.ferreira@example.com', '987456129', '2024-06-25', 'avatar6.png', 'FINALIZADO', 3, 22, 2, 18.9, '66679', '1970-12-08',  40.0, 2, 1);
INSERT INTO tbl_colaborador (primeiro_nome, sobrenome, cpf, email, telefone, data_admissao, avatar, sts_integracao, qtd_respondidas, pontuacao, qtd_certas, porc_progresso, numero_matricula, data_nascimento, porc_acertos, id_departamento, id_integracao) VALUES ('Juliana', 'Martins', '321.694.987-00', 'juliana1.martins@example.com', '789654329', '2024-06-25', 'avatar7.png', 'FINALIZADO', 9, 68, 7, 41.2, '90901', '1988-02-08',  70.0, 2, 1);
INSERT INTO tbl_colaborador (primeiro_nome, sobrenome, cpf, email, telefone, data_admissao, avatar, sts_integracao, qtd_respondidas, pontuacao, qtd_certas, porc_progresso, numero_matricula, data_nascimento, porc_acertos, id_departamento, id_integracao) VALUES ('Felipe', 'Gomes', '987.391.654-00', 'felipe1.gomes@example.com', '456789129', '2024-06-25', 'avatar8.png', 'FINALIZADO', 6, 45, 4, 31.5, '73188', '1950-08-29',  62.5, 2, 1);

INSERT INTO tbl_integracao (data_inicio, hora_inicio, data_fim, hora_fim, status, qtd_colaboradores, media_progresso, media_acertos, id_rh, id_departamento) VALUES ('2024-06-21', '19:18', '2024-06-30', '18:00', 'NAO_INICIADO', 8, 60.0, 95.0, 1, 1);

INSERT INTO tbl_colaborador (primeiro_nome, sobrenome, cpf, email, telefone, data_admissao, avatar, sts_integracao, qtd_respondidas, pontuacao, qtd_certas, porc_progresso, numero_matricula, data_nascimento, porc_acertos, id_departamento, id_integracao) VALUES ('Larissa', 'Almeida', '289.092.345-62', 'larissa2.almeida@example.com', '289012341', '2024-06-25', 'avatar1.png', 'NAO_FEZ', 0, 0, 0, 0.0, '73998', '1950-08-29', 0.0, 1, 2);
INSERT INTO tbl_colaborador (primeiro_nome, sobrenome, cpf, email, telefone, data_admissao, avatar, sts_integracao, qtd_respondidas, pontuacao, qtd_certas, porc_progresso, numero_matricula, data_nascimento, porc_acertos, id_departamento, id_integracao) VALUES ('João', 'Silva', '223.496.789-02', 'joao2.silva@example.com', '287654321', '2024-06-25', 'avatar2.png', 'NAO_FEZ', 0, 0, 0, 0.0, '73228', '1970-08-29', 0.0, 1, 2);
INSERT INTO tbl_colaborador (primeiro_nome, sobrenome, cpf, email, telefone, data_admissao, avatar, sts_integracao, qtd_respondidas, pontuacao, qtd_certas, porc_progresso, numero_matricula, data_nascimento, porc_acertos, id_departamento, id_integracao) VALUES ('Maria', 'Santos', '287.694.321-02', 'maria2.santos@example.com', '254987321', '2024-06-25', 'avatar3.png', 'NAO_FEZ', 0, 0, 0, 0.0, '74448', '1950-08-29', 0.0, 1, 2);
INSERT INTO tbl_colaborador (primeiro_nome, sobrenome, cpf, email, telefone, data_admissao, avatar, sts_integracao, qtd_respondidas, pontuacao, qtd_certas, porc_progresso, numero_matricula, data_nascimento, porc_acertos, id_departamento, id_integracao) VALUES ('Pedro', 'Oliveira', '256.799.123-02', 'pedro2.oliveira@example.com', '221654981', '2024-06-25', 'avatar4.png', 'NAO_FEZ', 0, 0, 0, 0.0, '73678', '1950-08-29', 0.0, 1, 2);
INSERT INTO tbl_colaborador (primeiro_nome, sobrenome, cpf, email, telefone, data_admissao, avatar, sts_integracao, qtd_respondidas, pontuacao, qtd_certas, porc_progresso, numero_matricula, data_nascimento, porc_acertos, id_departamento, id_integracao) VALUES ('Ana', 'Rodrigues', '254.391.987-02', 'ana2.rodrigues@example.com', '256123791', '2024-06-25', 'avatar5.png', 'NAO_FEZ', 0, 0, 0, 0.0, '73000', '1950-08-29', 0.0, 1, 2);
INSERT INTO tbl_colaborador (primeiro_nome, sobrenome, cpf, email, telefone, data_admissao, avatar, sts_integracao, qtd_respondidas, pontuacao, qtd_certas, porc_progresso, numero_matricula, data_nascimento, porc_acertos, id_departamento, id_integracao) VALUES ('Carlos', 'Ferreira', '289.193.456-02', 'carlos2.ferreira@example.com', '287456121', '2024-06-25', 'avatar6.png', 'NAO_FEZ', 0, 0, 0, 0.0, '70008', '1955-03-15', 0.0, 1, 2);
INSERT INTO tbl_colaborador (primeiro_nome, sobrenome, cpf, email, telefone, data_admissao, avatar, sts_integracao, qtd_respondidas, pontuacao, qtd_certas, porc_progresso, numero_matricula, data_nascimento, porc_acertos, id_departamento, id_integracao) VALUES ('Juliana', 'Martins', '221.694.987-02', 'juliana2.martins@example.com', '289654321', '2024-06-25', 'avatar7.png', 'NAO_FEZ', 0, 0, 0, 0.0, '71118', '1989-09-03', 0.0, 1, 2);
INSERT INTO tbl_colaborador (primeiro_nome, sobrenome, cpf, email, telefone, data_admissao, avatar, sts_integracao, qtd_respondidas, pontuacao, qtd_certas, porc_progresso, numero_matricula, data_nascimento, porc_acertos, id_departamento, id_integracao) VALUES ('Felipe', 'Gomes', '287.391.654-02', 'felipe2.gomes@example.com', '256789121', '2024-06-25', 'avatar8.png', 'NAO_FEZ', 0, 0, 0, 0.0, '73898', '1975-08-29', 0.0, 1, 2);
