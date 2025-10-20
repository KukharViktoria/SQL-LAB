CREATE TABLE [employee] (
	[employee_id] int IDENTITY(1,1) NOT NULL UNIQUE,
	[user_name] nvarchar(30) NOT NULL,
	[first_name] nvarchar(30) NOT NULL,
	[last_name] nvarchar(30) NOT NULL,
	[position] nvarchar(15) NOT NULL,
	[employment_date] date NOT NULL,
	[departament_id] int,
	[manager_id] int,
	[rate] float(53) NOT NULL,
	[bonus] float(53),
	PRIMARY KEY ([employee_id])
);

CREATE TABLE [departament] (
	[departament_id] int NOT NULL,
	[departament_name] nvarchar(30) NOT NULL,
	[city] nvarchar(30) NOT NULL,
	[street] nvarchar(40) NOT NULL,
	[building_no] int NOT NULL,
	PRIMARY KEY ([departament_id])
);

CREATE TABLE [product] (
	[product_id] int NOT NULL,
	[product_name] nvarchar(40) NOT NULL,
	[product_description] nvarchar(150) NOT NULL,
	[cetegory] nvarchar(15) NOT NULL,
	[manyfacture] nvarchar(30) NOT NULL,
	[product_type] nvarchar(15) NOT NULL,
	[amout] int NOT NULL,
	[price] float(53) NOT NULL,
	PRIMARY KEY ([product_id])
);

CREATE TABLE [costumer] (
	[costumer_id] int IDENTITY(1,1) NOT NULL,
	[first_name] nvarchar(30) NOT NULL,
	[last_name] nvarchar(30) NOT NULL,
	[genger] nvarchar(1) NOT NULL,
	[birth_date] date NOT NULL,
	[photo_number] int NOT NULL,
	[email] nvarchar(50) NOT NULL,
	[discout] int NOT NULL,
	PRIMARY KEY ([costumer_id])
);

CREATE TABLE [ordres] (
	[orders_id] int IDENTITY(1,1) NOT NULL,
	[employee_id] int NOT NULL,
	[product_id] int NOT NULL,
	[custumer_id] int NOT NULL,
	[transaction_type] int NOT NULL,
	[transsction_moment] datetime NOT NULL,
	[amount] int NOT NULL,
	PRIMARY KEY ([orders_id])
);

ALTER TABLE [employee] ADD CONSTRAINT [employee_fk6] FOREIGN KEY ([departament_id]) REFERENCES [departament]([departament_id]);

ALTER TABLE [employee] ADD CONSTRAINT [employee_fk7] FOREIGN KEY ([manager_id]) REFERENCES [employee]([employee_id]);



ALTER TABLE [ordres] ADD CONSTRAINT [ordres_fk1] FOREIGN KEY ([employee_id]) REFERENCES [employee]([employee_id]);

ALTER TABLE [ordres] ADD CONSTRAINT [ordres_fk2] FOREIGN KEY ([product_id]) REFERENCES [product]([product_id]);

ALTER TABLE [ordres] ADD CONSTRAINT [ordres_fk3] FOREIGN KEY ([custumer_id]) REFERENCES [costumer]([costumer_id]);