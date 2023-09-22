DROP DATABASE IF EXISTS app_food;
CREATE DATABASE app_food;
USE app_food;
CREATE TABLE users (
	user_id INT PRIMARY KEY AUTO_INCREMENT,
	full_name VARCHAR(100) NOT NULL,
	email VARCHAR(100) NOT NULL,
	password VARCHAR(50) NOT NULL
);

INSERT INTO users (full_name, email, password)
VALUES
    ('John Doe', 'john.doe@example.com', 'password123'),
    ('Jane Smith', 'jane.smith@example.com', 'securepassword'),
    ('Bob Stanley', 'bob.stanley@example.com', '123word'),
    ('Harry Potter', 'harry.potter@example.com', 'harry'),
    ('Alice Johnson', 'alice.johnson@example.com', 'letmein'),
    ('Sarah Johnson', 'sarah@example.com', 'sarahs_password'),
    ('Sarah Brown', 'sarahB@example.com', 'sarah_password'),
    ('Michael Brown', 'michael@example.com', 'mikesecurepass');
    
CREATE TABLE food_types (
	type_id INT PRIMARY KEY AUTO_INCREMENT,
	type_name VARCHAR(100) NOT NULL
);

INSERT INTO food_types (type_name) VALUES
	('Pizza'),
    ('Sushi'),
    ('Burger'),
    ('Pasta'),
    ('Steak');

CREATE TABLE foods (
	food_id INT PRIMARY KEY AUTO_INCREMENT,
	food_name VARCHAR(100) NOT NULL,
	image VARCHAR(100),
	price FLOAT NOT NULL,
	description VARCHAR(125),
	type_id INT,
	FOREIGN KEY (type_id) REFERENCES food_types(type_id)
);

INSERT INTO foods (food_name, image, price, description, type_id) VALUES
	('Pizza Hải Sản','pizza-hai-san.jpg', 12, 'tôm mực, size nhỏ', 1),
	('Pizza Bò','pizza-bo.jpg', 10, 'bò, size nhỏ', 1),
	('Sushi Trứng','sushi-trung.jpg', 2.5, '2 miếng', 2),
	('Burger special','burger-special.jpg', 5, 'fullsize, full toping',3),
	('Burger bò','burger-special.jpg', 3.5, 'nhân bò', 3),
	('Pasta Hải Sản','pasta-hai-san.jpg', 3.5, 'sốt cay', 4),
	('Texas Steak','texas-steak.jpg', 30, 'kèm rượu vang', 5),
	('Chicago Steak','chicago-steak.jpg', 35, 'kèm rượu vang', 5);
	
CREATE TABLE sub_foods (
	sub_id INT PRIMARY KEY AUTO_INCREMENT,
	sub_name VARCHAR(50),
	sub_price (float),
	food_id INT,
	FOREIGN KEY (food_id) REFERENCES foods(food_id)
);


CREATE TABLE restaurants (
	res_id INT PRIMARY KEY AUTO_INCREMENT,
	res_name VARCHAR(100) NOT NULL,
	image VARCHAR(100),
	description VARCHAR(100)
);
	
INSERT INTO restaurants (res_name, image, description)
VALUES
    ('Restaurant A', 'http://example.com/restaurantA.jpg', 'A cozy restaurant with a variety of cuisines.'),
    ('Restaurant B', 'http://example.com/restaurantB.jpg', 'An elegant dining experience with a focus on seafood.'),
    ('Restaurant C', 'http://example.com/restaurantC.jpg', 'A family-friendly place known for its pizza and pasta.'),
    ('Restaurant D', 'http://example.com/restaurantC.jpg', 'nothing special');

CREATE TABLE rate_res (
	user_id INT,
	res_id INT,
	amount INT,
	date_rate DATETIME,
	FOREIGN KEY (user_id) REFERENCES users(user_id),
	FOREIGN KEY (res_id) REFERENCES restaurants(res_id)
);

INSERT INTO rate_res(user_id, res_id, amount, date_rate) VALUES
	(1, 3, 1, '2022-12-05 01:30:59'),
	(3, 1, 2, '2022-10-05 11:05:59'),
	(1, 2, 3, '2022-10-15 10:25:15'),
	(4, 4, 2, '2023-02-02 15:15:12'),
	(4, 2, 1, '2023-02-03 08:10:12'),
	(5, 1, 3, '2023-06-05 08:20:10'),
	(7, 2, 5, '2023-07-22 14:45:00'),
    (3, 4, 3, '2023-08-23 19:15:00'),
    (6, 3, 4, '2023-07-24 12:00:00');
	
CREATE TABLE like_res (
	user_id INT,
	res_id INT,
	date_like DATETIME,
	FOREIGN KEY (user_id) REFERENCES users(user_id),
	FOREIGN KEY (res_id) REFERENCES restaurants(res_id)
);

INSERT INTO like_res(user_id, res_id, date_like) VALUES
	(1,3, '2022-12-05 01:50:10'),
	(3,1, '2022-10-05 11:06:00'),
	(1,2, '2022-10-15 10:35:15'),
	(4,4, '2023-02-02 15:18:02'),
	(4,2, '2023-02-03 08:16:32'),
	(5,1, '2023-06-05 08:30:12'),
	(6,2, '2023-07-22 14:45:00'),
    (7,4, '2023-08-23 19:15:00'),
    (7,1, '2023-08-23 19:15:00'),
    (6,4, '2023-07-24 12:00:00');

CREATE TABLE orders(
	order_id INT PRIMARY KEY AUTO_INCREMENT,
	user_id INT,
	food_id INT,
	amount INT ,
	code VARCHAR (20),
	arr_sub_id VARCHAR (20),
	FOREIGN KEY (user_id) REFERENCES users(user_id),
	FOREIGN KEY (food_id) REFERENCES foods(food_id)
);

INSERT INTO orders (user_id, food_id, amount) VALUES
	(1,3,1),
	(4,3,2),
	(4,1,1),
	(1,2,3),
	(3,5,1),
	(5,4,2),
	(8,5,2),
	(1,1,2);
		
-- Tìm 5 người đã like nhà hàng nhiều nhất
SELECT COUNT(like_res.user_id) AS count_like_user, users.full_name, users.email, users.user_id
FROM users INNER JOIN like_res ON users.user_id = like_res.user_id
GROUP BY users.full_name, users.email, users.user_id
ORDER BY COUNT(like_res.user_id) DESC
LIMIT 5;

-- Tìm 2 nhà hàng có lượt like nhiều nhất
SELECT COUNT(like_res.res_id) AS count_like_res, restaurants.res_id, restaurants.res_name
FROM like_res INNER JOIN restaurants ON like_res.res_id = restaurants.res_id
GROUP BY restaurants.res_id, restaurants.res_name
ORDER BY count_like_res DESC
LIMIT 2;

-- Tìm người đã đặt hàng nhiều nhất
SELECT COUNT(orders.user_id) AS count_orders, users.user_id, users.full_name, users.email
FROM orders INNER JOIN users ON orders.user_id = users.user_id
GROUP BY users.user_id, users.full_name, users.email
ORDER BY count_orders DESC
LIMIT 1;

-- Tìm người dùng không hoạt động trong hệ thống (không đặt hàng, không like, không đánh giá nhà hàng)
SELECT users.user_id, users.full_name, users.email FROM users 
LEFT JOIN like_res ON users.user_id = like_res.user_id
LEFT JOIN rate_res ON users.user_id = rate_res.user_id
LEFT JOIN orders ON users.user_id = orders.user_id
WHERE like_res.user_id IS NULL && rate_res.user_id IS NULL && orders.user_id iS NULL;
