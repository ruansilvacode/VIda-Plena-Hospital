CREATE DATABASE VidaPlenaHospital;
USE VidaPlenaHospital;

-- Tabela de Pacientes
CREATE TABLE Pacientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    cpf VARCHAR(14) UNIQUE,
    data_nascimento DATE,
    telefone VARCHAR(20),
    endereco VARCHAR(150)
);

-- Tabela de Funcionários
CREATE TABLE Funcionarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    cargo VARCHAR(50),
    salario DECIMAL(10,2),
    data_admissao DATE,
    status VARCHAR(20) -- 'Ativo' ou 'Inativo'
);

-- Tabela de Especialidades Médicas
CREATE TABLE Especialidades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100)
);

-- Tabela de Consultas
CREATE TABLE Consultas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT,
    id_funcionario INT,
    id_especialidade INT,
    data_consulta DATE,
    valor DECIMAL(8,2),
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id),
    FOREIGN KEY (id_funcionario) REFERENCES Funcionarios(id),
    FOREIGN KEY (id_especialidade) REFERENCES Especialidades(id)
);

-- Tabela de Medicamentos
CREATE TABLE Medicamentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    estoque INT,
    preco_unitario DECIMAL(8,2)
);

-- Tabela de Internações
CREATE TABLE Internacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT,
    quarto VARCHAR(10),
    data_entrada DATE,
    data_saida DATE,
    custo DECIMAL(10,2),
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id)
);

-- Pacientes
INSERT INTO Pacientes (nome, cpf, data_nascimento, telefone, endereco) VALUES
('Ana Paula Mendes', '123.456.789-00', '1990-05-15', '(11) 99876-5432', 'Rua das Flores, 120'),
('Carlos Eduardo Lima', '987.654.321-00', '1985-09-23', '(11) 98564-1123', 'Av. Brasil, 450'),
('Fernanda Costa Silva', '456.789.123-00', '1978-12-10', '(11) 98765-3321', 'Rua A, 77'),
('Marcos Vinicius Rocha', '321.654.987-00', '2000-07-30', '(11) 97555-9090', 'Av. Central, 900'),
('Juliana Faria Lopes', '789.123.456-00', '1995-03-05', '(11) 98987-7788', 'Rua B, 55');

-- Funcionários
INSERT INTO Funcionarios (nome, cargo, salario, data_admissao, status) VALUES
('Dr. Ricardo Martins', 'Médico', 15000.00, '2015-03-20', 'Ativo'),
('Enf. Maria Clara', 'Enfermeira', 5800.00, '2018-06-12', 'Ativo'),
('Dr. Fernando Souza', 'Médico', 14500.00, '2019-11-01', 'Ativo'),
('Lucas Almeida', 'Recepcionista', 3200.00, '2021-02-18', 'Ativo'),
('Patricia Gomes', 'Administrativo', 4500.00, '2020-08-25', 'Inativo');

-- Especialidades
INSERT INTO Especialidades (nome) VALUES
('Cardiologia'),
('Dermatologia'),
('Ortopedia'),
('Pediatria'),
('Neurologia');

-- Consultas
INSERT INTO Consultas (id_paciente, id_funcionario, id_especialidade, data_consulta, valor) VALUES
(1, 1, 1, '2024-05-10', 350.00),
(2, 3, 2, '2024-05-12', 300.00),
(3, 1, 3, '2024-05-15', 400.00),
(4, 3, 4, '2024-05-18', 250.00),
(5, 1, 5, '2024-05-20', 500.00);

-- Medicamentos
INSERT INTO Medicamentos (nome, estoque, preco_unitario) VALUES
('Dipirona', 150, 5.00),
('Amoxicilina', 80, 20.00),
('Losartana', 120, 15.50),
('Omeprazol', 200, 10.00),
('Ibuprofeno', 100, 8.00);

-- Internações
INSERT INTO Internacoes (id_paciente, quarto, data_entrada, data_saida, custo) VALUES
(1, '101A', '2024-05-01', '2024-05-05', 4500.00),
(3, '202B', '2024-05-08', '2024-05-10', 3000.00),
(5, '303C', '2024-05-15', '2024-05-20', 7000.00);

-- Consultas

-- Listar todos os pacientes internados atualmente
SELECT nome, quarto
FROM Pacientes P
JOIN Internacoes I ON P.id = I.id_paciente
WHERE data_saida IS NULL OR data_saida >= CURDATE();

-- Listar médicos ativos
SELECT nome 
FROM Funcionarios
WHERE cargo = 'Médico' AND status = 'Ativo';

-- Listar medicamentos com estoque abaixo de 100 unidades
SELECT nome, estoque
FROM Medicamentos
WHERE estoque < 100;

-- Total de consultas e média de valor por especialidade
SELECT E.nome AS especialidade, 
       COUNT(C.id) AS qtd_consultas,
       AVG(C.valor) AS media_valor
FROM Consultas C
JOIN Especialidades E ON C.id_especialidade = E.id
GROUP BY E.nome;

-- Cargos com média salarial acima de R$ 5.000,00
SELECT cargo, AVG(salario) AS media_salarial
FROM Funcionarios
GROUP BY cargo
HAVING media_salarial > 5000;

-- Formatar nomes dos pacientes em maiúsculo e calcular idade
SELECT 
    UPPER(nome) AS nome_maiusculo,
    TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE()) AS idade
FROM Pacientes;

-- Classificar funcionários conforme o status (ativo ou inativo)
SELECT nome,
       CASE 
           WHEN status = 'Ativo' THEN 'Funcionando'
           WHEN status = 'Inativo' THEN 'Desligado'
           ELSE 'Desconhecido'
       END AS situacao
FROM Funcionarios;
