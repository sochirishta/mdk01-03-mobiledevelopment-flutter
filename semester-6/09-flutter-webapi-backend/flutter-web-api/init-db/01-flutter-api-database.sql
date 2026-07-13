CREATE TABLE Products(
	id_product SERIAL PRIMARY KEY,
	name_product VARCHAR(100) UNIQUE NOT NULL CHECK (length(trim(name_product)) > 0),
	price NUMERIC(10, 2) NOT NULL,
	quantity INT NOT NULL,
	imageUrl VARCHAR(500) NOT NULL
);

CREATE TABLE Users(
	id_user SERIAL PRIMARY KEY,
	user_name VARCHAR(100) UNIQUE NOT NULL CHECK (length(trim(user_name)) > 0),
	user_pwd VARCHAR(100) NOT NULL CHECK (length(trim(user_pwd)) > 0)
);

CREATE TABLE CartItems(
	id_cartItem SERIAL PRIMARY KEY,
	product_id INT REFERENCES Products(id_product) ON DELETE SET NULL,
	user_id INT REFERENCES Users(id_user) ON DELETE SET NULL,
	addedQuantity INT NOT NULL
);

ALTER TABLE "users" DROP CONSTRAINT IF EXISTS "users_user_pwd_key";

SELECT constraint_name 
FROM information_schema.table_constraints 
WHERE table_name = 'users' AND constraint_type = 'UNIQUE';
