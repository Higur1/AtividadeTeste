CREATE DATABASE ex9
GO
USE ex9
GO
CREATE TABLE editora (
codigo			INT				NOT NULL,
nome			VARCHAR(30)		NOT NULL,
site			VARCHAR(40)		NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE autor (
codigo			INT				NOT NULL,
nome			VARCHAR(30)		NOT NULL,
biografia		VARCHAR(100)	NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE estoque (
codigo			INT				NOT NULL,
nome			VARCHAR(100)	NOT NULL	UNIQUE,
quantidade		INT				NOT NULL,
valor			DECIMAL(7,2)	NOT NULL	CHECK(valor > 0.00),
codEditora		INT				NOT NULL,
codAutor		INT				NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (codEditora) REFERENCES editora (codigo),
FOREIGN KEY (codAutor) REFERENCES autor (codigo)
)
GO
CREATE TABLE compra (
codigo			INT				NOT NULL,
codEstoque		INT				NOT NULL,
qtdComprada		INT				NOT NULL,
valor			DECIMAL(7,2)	NOT NULL,
dataCompra		DATE			NOT NULL
PRIMARY KEY (codigo, codEstoque, dataCompra)
FOREIGN KEY (codEstoque) REFERENCES estoque (codigo)
)
GO
INSERT INTO editora VALUES
(1,'Pearson','www.pearson.com.br'),
(2,'Civilização Brasileira',NULL),
(3,'Makron Books','www.mbooks.com.br'),
(4,'LTC','www.ltceditora.com.br'),
(5,'Atual','www.atualeditora.com.br'),
(6,'Moderna','www.moderna.com.br')
GO
INSERT INTO autor VALUES
(101,'Andrew Tannenbaun','Desenvolvedor do Minix'),
(102,'Fernando Henrique Cardoso','Ex-Presidente do Brasil'),
(103,'Diva Marília Flemming','Professora adjunta da UFSC'),
(104,'David Halliday','Ph.D. da University of Pittsburgh'),
(105,'Alfredo Steinbruch','Professor de Matemática da UFRS e da PUCRS'),
(106,'Willian Roberto Cereja','Doutorado em Lingüística Aplicada e Estudos da Linguagem'),
(107,'William Stallings','Doutorado em Ciências da Computacão pelo MIT'),
(108,'Carlos Morimoto','Criador do Kurumin Linux')
GO
INSERT INTO estoque VALUES
(10001,'Sistemas Operacionais Modernos ',4,108.00,1,101),
(10002,'A Arte da Política',2,55.00,2,102),
(10003,'Calculo A',12,79.00,3,103),
(10004,'Fundamentos de Física I', 26,68.00,4,104),
(10005,'Geometria Analítica', 1,95.00,3,105),
(10006,'Gramática Reflexiva', 10,49.00,5,106),
(10007,'Fundamentos de Física III', 1,78.00,4,104),
(10008,'Calculo B', 3,95.00,3,103)
GO
INSERT INTO compra VALUES
(15051,10003,2,158.00,'2021-07-04'),
(15051,10008,1,95.00,'2021-07-04'),
(15051,10004,1,68.00,'2021-07-04'),
(15051,10007,1,78.00,'2021-07-04'),
(15052,10006,1,49.00,'2021-07-05'),
(15052,10002,3,165.00,'2021-07-05'),
(15053,10001,1,108.00,'2021-07-05'),
(15054,10003,1,79.00,'2021-08-06'),
(15054,10008,1,95.00,'2021-08-06')


--Ex 1
SELECT et.nome AS nome_livro, 
et.valor AS valor_unitario,
ed.nome AS nome_editora, 
at.nome AS nome_autor
FROM estoque et INNER JOIN editora ed 
ON et.codEditora = ed.codigo 
INNER JOIN autor at 
ON et.codAutor = at.codigo 
LEFT OUTER JOIN compra cp 
ON et.codigo = cp.codEstoque
WHERE cp.codigo IS NOT NULL


--Ex 2
SELECT et.nome, co.qtdComprada, co.valor
FROM estoque et INNER JOIN compra co 
ON et.codigo = co.codEstoque 
WHERE co.codigo = 15051

--Ex 3
SELECT et.nome AS nome_livro, 
	CASE 
		WHEN LEN(site) > 10 THEN
			SUBSTRING(site, 5, 20)
		ELSE
			site
		END AS site_editora
FROM estoque et INNER JOIN editora ed 
ON et.codEditora = ed.codigo 
WHERE ed.nome = 'Makron books'

--Ex 4
SELECT et.nome AS nome_livro, au.biografia
FROM estoque et INNER JOIN autor au 
ON et.codAutor = au.codigo 
WHERE au.nome = 'David Halliday'

--Ex 5
Select co.codigo AS codigo_compra, co.qtdComprada 
FROM compra co INNER JOIN estoque et 
ON et.codigo = co.codEstoque 
WHERE et.nome = 'Sistemas Operacionais Modernos'

--Ex6 
SELECT et.nome AS nome_livro
FROM compra cp RIGHT OUTER JOIN estoque et
ON et.codigo = cp.codEstoque
WHERE cp.codigo is NULL

--Ex7
SELECT et.nome AS nome_livro
FROM estoque et LEFT OUTER JOIN compra cp 
ON et.codigo = cp.codEstoque
WHERE et.codigo IS NULL

--Ex8
SELECT 
	CASE 
		WHEN LEN(site) > 10 THEN
			SUBSTRING(site, 5, 20)
		ELSE
			site
		END AS site_editora
FROM editora ed LEFT OUTER JOIN estoque et 
ON ed.codigo = et.codEditora
WHERE et.codEditora  IS NULL

--Ex9
SELECT at.nome, 
	CASE 
		WHEN SUBSTRING(at.biografia, 1, 9) = 'Doutorado' THEN
			'Ph.D.' + SUBSTRING(at.biografia,10, 50) 
		ELSE
			at.biografia
		END AS bibiografia
FROM autor at LEFT OUTER JOIN estoque et 
ON at.codigo = et.codAutor 
WHERE et.codAutor IS NULL

--Ex10
SELECT at.nome, MAX(et.valor) AS valor
FROM autor at INNER JOIN estoque et 
ON at.codigo = et.codAutor
GROUP BY at.nome
ORDER BY valor DESC

--Ex11

SELECT codigo, 
SUM(qtdComprada) AS total_livros, 
SUM(valor) as soma_valor_gasto 
FROM compra
GROUP BY codigo
ORDER BY codigo

--Ex12
SELECT ed.nome, 
AVG(et.valor) AS valor_medio
FROM editora ed INNER JOIN estoque et 
ON ed.codigo = et.codEditora
GROUP BY ed.nome

--Ex13
Select et.nome, quantidade,
	CASE 
		WHEN et.quantidade < 5 THEN 'Produto em ponto de pedido' 
		WHEN et.quantidade >=5 AND et.quantidade <= 10 THEN 'Produto acabando'
        WHEN et.quantidade > 10 THEN 'Estoque suficiente'
		END as status,
		ed.nome, 
	CASE 
		WHEN LEN(site) > 10 THEN
			SUBSTRING(site, 5, 20)
		ELSE
			site
		END AS site_editora
FROM editora ed INNER JOIN estoque et 
ON ed.codigo = et.codEditora
ORDER BY et.quantidade

--Ex14
SELECT et.codigo, et.nome, at.nome,
	CASE 
		WHEN (ed.site IS NULL) THEN
			ed.nome
		ELSE
			ed.nome + ' - ' + ed.site
	END as info_editora
FROM estoque et INNER JOIN autor at 
ON et.codAutor = at.codigo 
INNER JOIN editora ed 
ON et.codEditora = ed.codigo

--Ex15
SELECT codigo, 
DATEDIFF(DAY, dataCompra, GETDATE()) AS dias_dif, 
DATEDIFF(MONTH, dataCompra, GETDATE()) as meses_dif 
FROM compra

--Ex16
SELECT codigo, SUM(valor) as valor_total 
FROM compra
GROUP BY codigo
HAVING SUM(valor) > 200
