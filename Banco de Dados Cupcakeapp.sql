USE cupcakeapp;
CREATE TABLE Usuario (
  id_usuario INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  senha VARCHAR(100) NOT NULL,
  data_nascimento DATE,
  endereco VARCHAR(255),
  data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Cupcake (
  id_cupcake INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(100) NOT NULL,
  descricao TEXT,
  preco DECIMAL(8,2) NOT NULL,
  categoria VARCHAR(50),
  imagem VARCHAR(255)
);

CREATE TABLE CupcakePersonalizado (
  id_personalizado INT PRIMARY KEY AUTO_INCREMENT,
  id_usuario INT NOT NULL,
  massa VARCHAR(50),
  recheio VARCHAR(50),
  cobertura VARCHAR(50),
  adicionais TEXT,
  preco_final DECIMAL(8,2),
  FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

CREATE TABLE Cupom (
  id_cupom INT PRIMARY KEY AUTO_INCREMENT,
  codigo VARCHAR(50) UNIQUE NOT NULL,
  valor_desconto DECIMAL(5,2),
  data_validade DATE
  );
  
CREATE TABLE Pedido (
  id_pedido INT PRIMARY KEY AUTO_INCREMENT,
  id_usuario INT NOT NULL,
  id_cupom INT,
  data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(50),
  valor_total DECIMAL(10,2),
  forma_pagamento VARCHAR(50),
  endereco_entrega VARCHAR(255),
  FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
  FOREIGN KEY (id_cupom) REFERENCES Cupom(id_cupom)
);

CREATE TABLE ItemPedido (
  id_item INT PRIMARY KEY AUTO_INCREMENT,
  id_pedido INT NOT NULL,
  id_cupcake INT NOT NULL,
  quantidade INT,
  preco_unitario DECIMAL(8,2),
  FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
  FOREIGN KEY (id_cupcake) REFERENCES Cupcake(id_cupcake)
);

CREATE TABLE Avaliacao (
  id_avaliacao INT PRIMARY KEY AUTO_INCREMENT,
  id_usuario INT NOT NULL,
  id_cupcake INT NOT NULL,
  nota INT CHECK (nota BETWEEN 1 AND 5),
  comentario TEXT,
  data_avaliacao DATETIME DEFAULT CURRENT_TIMESTAMP,
  status_moderacao VARCHAR(20),
  FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
  FOREIGN KEY (id_cupcake) REFERENCES Cupcake(id_cupcake)
);

CREATE TABLE Notificacao (
  id_notificacao INT PRIMARY KEY AUTO_INCREMENT,
  id_usuario INT NOT NULL,
  mensagem TEXT,
  data_envio DATETIME DEFAULT CURRENT_TIMESTAMP,
  tipo VARCHAR(50),
  FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

CREATE TABLE Suporte (
  id_suporte INT PRIMARY KEY AUTO_INCREMENT,
  id_usuario INT NOT NULL,
  canal VARCHAR(20),
  mensagem TEXT,
  data_envio DATETIME DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(20),
  FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);
  RENAME TABLE itempedido TO item_pedido;
  ALTER TABLE notificacao ADD COLUMN titulo VARCHAR(100);
  ALTER TABLE cupcake_personalizado ADD COLUMN observacoes TEXT;
  ALTER TABLE cupcake_personalizado ADD COLUMN decoracao VARCHAR(100);
  ALTER TABLE cupcake_personalizado ADD COLUMN endereco_entrega VARCHAR(200),
  ADD COLUMN forma_pagamento VARCHAR(50),
  ADD COLUMN cupom_utilizado VARCHAR(20);
  ALTER TABLE cupcake_personalizado ADD COLUMN data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP;
  ALTER TABLE cupom ADD COLUMN ativo BOOLEAN DEFAULT TRUE;
  ALTER TABLE pedido ADD COLUMN cupom_utilizado VARCHAR(20);

  -- Usuários
INSERT INTO usuario (nome, email, senha, data_nascimento, endereco)
VALUES
('João Gabriel', 'joao@email.com', '12345678', '2000-05-14', 'Rua das Flores, 123'),
('Mariana Souza', 'mariana@email.com', 'senhaSegura99', '1998-10-02', 'Av. Central, 890'),
('Pedro Lima', 'pedro@email.com', 'cupcake@123', '2001-03-20', 'Rua dos Sabores, 45');

  -- Cupcakes
INSERT INTO cupcake (nome, descricao, preco, categoria, imagem)
VALUES
('Chocolate Clássico', 'Cupcake de chocolate com cobertura de brigadeiro', 6.50, 'Chocolate', 'chocolate.jpg'),
('Limão Siciliano', 'Cupcake de limão com glacê suave', 5.80, 'Frutas', 'limao.jpg'),
('Red Velvet', 'Massa vermelha com cream cheese', 7.00, 'Especial', 'redvelvet.jpg'),
('Doce de Leite', 'Massa branca com recheio cremoso de doce de leite', 6.80, 'Tradicional', 'doce_de_leite.jpg');
  
  -- Cupons
INSERT INTO cupom (codigo, valor_desconto, data_validade)
VALUES
('BEMVINDO10', 10.00, '2025-12-31'),
('CUPCAKE5', 5.00, '2025-06-30');

  -- Pedidos
INSERT INTO pedido (id_usuario, id_cupom, status, valor_total, forma_pagamento, endereco_entrega)
VALUES
(1, 1, 'Pago', 19.30, 'Pix', 'Rua das Flores, 123'),
(2, NULL, 'Aguardando Pagamento', 13.00, 'Cartão de Crédito', 'Av. Central, 890'),
(3, 2, 'Entregue', 18.80, 'Boleto', 'Rua dos Sabores, 45');

  -- Itens de Pedido
INSERT INTO item_pedido (id_pedido, id_cupcake, quantidade, preco_unitario)
VALUES
(1, 1, 2, 6.50),
(1, 2, 1, 6.30),
(2, 4, 2, 6.50),
(3, 3, 2, 7.00);

 -- Avaliações
INSERT INTO avaliacao (id_usuario, id_cupcake, nota, comentario, status_moderacao)
VALUES
(1, 1, 5, 'Delicioso! Sabor incrível de chocolate.', 'Aprovado'),
(2, 3, 4, 'Muito bom, só podia ser um pouco mais doce.', 'Aprovado'),
(3, 4, 4, 'Gostoso demais, só podia ser um pouquinho menos doce, mas é o melhor cupcake que já comi!', 'Aprovado');

 -- Notificações
INSERT INTO notificacao (id_usuario, titulo, mensagem, tipo)
VALUES
(1, 'Seu pedido foi enviado!', 'Atualização de Pedido'),
(2, 'Promoção: Cupcakes com 10% de desconto hoje!', 'Promoção'),
(3, 'Seu pedido foi entregue com sucesso.', 'Atualização de Pedido');

 -- Suporte
INSERT INTO suporte (id_usuario, canal, mensagem, status)
VALUES
(2, 'chat', 'Meu pedido está demorando para chegar.', 'Aberto'),
(3, 'email', 'Não consigo aplicar meu cupom de desconto.', 'Resolvido');

 -- Ver todos os usuários
SELECT * FROM usuario;

 -- Ver cupcakes e seus preços
SELECT nome, preco FROM cupcake;

 -- Ver pedidos e seus donos
SELECT p.id_pedido, u.nome, p.status, p.valor_total
FROM pedido p
JOIN usuario u ON p.id_usuario = u.id_usuario;

 -- Ver avaliações com nomes de cupcakes
SELECT u.nome AS usuario, c.nome AS cupcake, a.nota, a.comentario
FROM avaliacao a
JOIN usuario u ON a.id_usuario = u.id_usuario
JOIN cupcake c ON a.id_cupcake = c.id_cupcake;

 -- Ver as notificações por usuário
SELECT 
    u.nome AS cliente,
    n.tipo,
    n.mensagem,
    n.data_envio
FROM notificacao n
JOIN usuario u ON n.id_usuario = u.id_usuario
ORDER BY n.data_envio DESC;

 -- Ver as mensagens do suporte
SELECT 
    s.id_suporte,
    u.nome AS cliente,
    s.canal,
    s.mensagem,
    s.status,
    s.data_envio
FROM suporte s
JOIN usuario u ON s.id_usuario = u.id_usuario
ORDER BY s.data_envio DESC;

