SET search_path TO marketplace;

INSERT INTO clientes (nome, email, cidade) VALUES
('Ana Souza', 'ana@email.com', 'Fortaleza'),
('Carlos Lima', 'carlos@email.com', 'Recife'),
('Juliana Rocha', 'juliana@email.com', 'São Paulo'),
('Marcos Silva', 'marcos@email.com', 'Rio de Janeiro'),
('Fernanda Alves', 'fernanda@email.com', 'Belo Horizonte');

INSERT INTO vendedores (nome_vendedor, comissao_percentual) VALUES
('Tech Store', 10.0),
('Gadget World', 12.5),
('Casa Digital', 8.0),
('Mega Eletrônicos', 11.0),
('Loja Conectada', 9.5);

INSERT INTO produtos (nome_produto, id_vendedor) VALUES
('Notebook Gamer', 1),
('Mouse Sem Fio', 1),
('Smartphone X', 2),
('Fone Bluetooth', 2),
('Monitor 27"', 3),
('Teclado Mecânico', 4),
('Webcam HD', 5);

INSERT INTO pedidos (id_cliente, data_pedido) VALUES
(1, '2024-03-01'),
(2, '2024-03-02'),
(3, '2024-03-03'),
(1, '2024-03-05'),
(4, '2024-03-06');

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 5000.00),
(1, 2, 2, 120.00),
(2, 3, 1, 3500.00),
(3, 4, 1, 250.00),
(4, 5, 1, 900.00),
(5, 6, 1, 450.00),
(5, 7, 1, 300.00);