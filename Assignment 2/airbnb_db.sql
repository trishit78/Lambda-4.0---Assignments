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
