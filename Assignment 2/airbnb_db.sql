create database airbnb_db;

use airbnb_db;

create table users(id INT auto_increment PRIMARY KEY,
fullName varchar(15) NOT NULL,
email varchar(20) NOT NULL UNIQUE,
ph_no INT NOT NULL ,
account_type enum('guest','host') NOT NULL,
signup_date Date NOT NULL
);

desc users;

drop table reviews;

create table listings(id INT auto_increment PRIMARY KEY ,
title varchar(30) NOT NULL,
host_id INT NOT NULL,
l_description varchar(50),
price_per_night INT NOT NULL,
city varchar(20) NOT NULL,
country varchar(20) NOT NULL,
no_of_bedrooms INT NOT NULL,
no_of_bathrooms INT NOT NULL,
/*
this host_id is referenced to users table id
*/
foreign key (host_id) references users(id)  
);

DELIMITER //
CREATE TRIGGER check_host_before_listing
before insert on listings
for each row
begin
	declare user_role ENUM('guest','host');
    
    select account_type INTO user_role
    from users
    where id = NEW.host_id;
    
    if user_role != 'host' THEN
		SIGNAL sqlstate '45000'
        set message_text = 'only hosts can make listings,';
	END IF;
END;
    
//


create table bookings(
	id INT PRIMARY KEY,
    guest_id INT NOT NULL,
    listing_id INT NOT NULL,
    foreign key(guest_id) references users(id),
    foreign key(listing_id) references listings(id),
    start_date Date NOT NULL,
    end_date Date NOT NULL,
    total_price INT NOT NULL,
    booking_status enum('confirmed','cancelled') NOT NULL
);

DELIMITER //
CREATE TRIGGER check_guest_before_booking
before insert on bookings
for each row
begin
	declare user_role ENUM('guest','host');
    
    select account_type INTO user_role
    from users
    where id = NEW.guest_id;
    
    if user_role != 'guest' THEN
		SIGNAL sqlstate '45000'
        set message_text = 'only guests can make bookings,';
	END IF;
END;
    
//


create table reviews(
	id INT auto_increment primary key,
    guest_id INT NOT NULL,
    listing_id INT NOT NULL,
    foreign key(guest_id) references users(id),
    foreign key(listing_id) references listings(id),
    rating INT NOT NULL CHECK(rating > 0 AND rating <=5),
    review_text varchar(50) NOT NULL,
    review_dateTime datetime default current_timestamp NOT NULL
);

DELIMITER //
CREATE TRIGGER check_guest_before_reviews
before insert on reviews
for each row
begin
	declare user_role ENUM('guest','host');
    
    select account_type INTO user_role
    from users
    where id = NEW.guest_id;
    
    if user_role != 'guest' THEN
		SIGNAL sqlstate '45000'
        set message_text = 'only guests can make bookings,';
	END IF;
END;
    
//


create table payments(
	id INT PRIMARY KEY,
    booking_id INT NOT NULL,
    foreign key(booking_id) references bookings(id),
    amount_paid INT NOT NULL,
    payment_method varchar(30) NOT NULL,
    payment_status enum('accepted','rejected','processing') not null
);




INSERT INTO users (fullName, email, ph_no, account_type, signup_date) VALUES
('Alice Green', 'alice@email.com', 1234890, 'guest', '2024-01-10'),
('Bob Smith', 'bob@email.com', 234501, 'host', '2024-01-15'),
('Charlie Brown', 'charlie@email.com', 349012, 'guest', '2024-02-01'),
('Diana Prince', 'diana@email.com', 490123, 'guest', '2024-02-05'),
('Ethan Hunt', 'ethan@email.com', 5671234, 'host', '2024-02-10'),
('Fiona Lake', 'fiona@email.com', 6782345, 'guest', '2024-02-15'),
('George Stone', 'george@email.com', 78901, 'host', '2024-03-01'),
('Hannah Miles', 'hannah@email.com', 834567, 'guest', '2024-03-05'),
('Ivan Moore', 'ivan@email.com', 945678, 'guest', '2024-03-10'),
('Julia White', 'julia@email.com', 123456, 'host', '2024-03-15');





INSERT INTO listings (title, host_id, l_description, price_per_night, city, country, no_of_bedrooms, no_of_bathrooms) VALUES
('Cozy Studio', 2, 'Comfortable and cozy', 50, 'New York', 'USA', 1, 1),
('Luxury Villa', 5, 'Beachfront villa', 300, 'Miami', 'USA', 5, 4),
('Downtown Apartment', 7, 'Close to everything', 120, 'Chicago', 'USA', 2, 2),
('Cabin in Woods', 2, 'Nature getaway', 80, 'Asheville', 'USA', 2, 1),
('City Center Flat', 5, 'Modern and bright', 100, 'Boston', 'USA', 1, 1),
('Oceanview Condo', 7, 'Stunning views', 200, 'Los Angeles', 'USA', 3, 2),
('Rustic Cottage', 2, 'Charming and cozy', 90, 'Portland', 'USA', 2, 2),
('Penthouse Suite', 5, 'Luxury downtown', 400, 'Seattle', 'USA', 3, 3),
('Tiny Home', 7, 'Efficient living', 60, 'Austin', 'USA', 1, 1),
('Mountain Lodge', 2, 'Ski retreat', 250, 'Denver', 'USA', 4, 3);



INSERT INTO bookings (id, guest_id, listing_id, start_date, end_date, total_price, booking_status) VALUES
(1, 1, 1, '2025-04-10', '2025-04-12', 100, 'confirmed'),
(2, 3, 2, '2025-05-01', '2025-05-05', 1200, 'confirmed'),
(3, 4, 3, '2025-06-10', '2025-06-12', 240, 'confirmed'),
(4, 6, 4, '2025-07-01', '2025-07-03', 160, 'confirmed'),
(5, 8, 5, '2025-08-15', '2025-08-18', 300, 'cancelled'),
(6, 9, 6, '2025-09-05', '2025-09-07', 400, 'confirmed'),
(7, 1, 7, '2025-10-10', '2025-10-12', 180, 'confirmed'),
(8, 3, 8, '2025-11-01', '2025-11-04', 1200, 'confirmed'),
(9, 4, 9, '2025-12-10', '2025-12-12', 120, 'confirmed'),
(10, 6, 10, '2026-01-01', '2026-01-05', 1000, 'confirmed');


INSERT INTO reviews (guest_id, listing_id, rating, review_text) VALUES
(1, 1, 5, 'Awesome stay!'),
(3, 2, 4, 'Loved the beach view.'),
(4, 3, 3, 'Good but noisy at night.'),
(6, 4, 5, 'Perfect nature escape!'),
(8, 5, 4, 'Great city location.'),
(9, 6, 5, 'Amazing views and clean.'),
(1, 7, 4, 'Cute cottage, would stay again.'),
(3, 8, 5, 'Luxurious experience!'),
(4, 9, 3, 'Small but cozy.'),
(6, 10, 5, 'Perfect for a ski trip!');


INSERT INTO payments (id, booking_id, amount_paid, payment_method, payment_status) VALUES
(1, 1, 100, 'Credit Card', 'accepted'),
(2, 2, 1200, 'PayPal', 'accepted'),
(3, 3, 240, 'Debit Card', 'accepted'),
(4, 4, 160, 'Credit Card', 'accepted'),
(5, 5, 0, 'Credit Card', 'rejected'), 
(6, 6, 400, 'UPI', 'accepted'),
(7, 7, 180, 'Credit Card', 'accepted'),
(8, 8, 1200, 'PayPal', 'accepted'),
(9, 9, 120, 'Debit Card', 'accepted'),
(10, 10, 1000, 'Credit Card', 'accepted');

