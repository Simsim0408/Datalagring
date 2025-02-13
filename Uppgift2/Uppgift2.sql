DROP TABLE IF EXISTS email CASCADE;
CREATE TABLE email (
 email_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 email_adress VARCHAR(500) NOT NULL
);

ALTER TABLE email ADD CONSTRAINT PK_email PRIMARY KEY (email_id);

DROP TABLE IF EXISTS email_person CASCADE;
CREATE TABLE email_person (
 person_id INT NOT NULL,
 email_id INT NOT NULL
);

ALTER TABLE email_person ADD CONSTRAINT PK_email_person PRIMARY KEY (person_id,email_id);


DROP TABLE IF EXISTS home_address CASCADE;
CREATE TABLE home_address (
 address_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 home_adress VARCHAR(500) NOT NULL
);

ALTER TABLE home_address ADD CONSTRAINT PK_home_address PRIMARY KEY (address_id);


DROP TABLE IF EXISTS address_person CASCADE;
CREATE TABLE address_person (
 person_id INT NOT NULL,
 address_id INT NOT NULL
);

ALTER TABLE address_person ADD CONSTRAINT PK_address_person PRIMARY KEY (person_id,address_id);

DROP TABLE IF EXISTS phone_number CASCADE;
CREATE TABLE phone_number (
 phone_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 phone_number VARCHAR(500) NOT NULL
);

ALTER TABLE phone_number ADD CONSTRAINT PK_phone_number PRIMARY KEY (phone_id);


DROP TABLE IF EXISTS phone_person CASCADE;
CREATE TABLE phone_person (
 person_id INT NOT NULL,
 phone_id INT NOT NULL
);

ALTER TABLE phone_person ADD CONSTRAINT PK_phone_person PRIMARY KEY (person_id,phone_id);


DROP TABLE IF EXISTS person CASCADE;
CREATE TABLE person (
 person_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 first_name VARCHAR(500) NOT NULL,
 last_name VARCHAR(500) NOT NULL
);

ALTER TABLE person ADD CONSTRAINT PK_person PRIMARY KEY (person_id);


DROP TABLE IF EXISTS student CASCADE;
CREATE TABLE student (
 person_id INT NOT NULL,
 sibling_id INT NOT NULL
);

ALTER TABLE student ADD CONSTRAINT PK_student PRIMARY KEY (person_id);


DROP TABLE IF EXISTS instrument CASCADE;
CREATE TABLE instrument (
 instrument_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 instrument_brand VARCHAR(500),
 price_monthly INT NOT NULL,
 total_available INT,
 instrument_type_id INT
);

ALTER TABLE instrument ADD CONSTRAINT PK_instrument PRIMARY KEY (instrument_id);


DROP TABLE IF EXISTS instrument_type CASCADE;
CREATE TABLE instrument_type (
 instrument_type_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 instrument_name VARCHAR(500) NOT NULL
);

ALTER TABLE instrument_type ADD CONSTRAINT PK_instrument_type PRIMARY KEY (instrument_type_id);


DROP TABLE IF EXISTS rented_instrument CASCADE;
CREATE TABLE rented_instrument (
 person_id INT NOT NULL,
 instrument_id INT NOT NULL,
 start_lease TIMESTAMP(10) NOT NULL,
 end_lease TIMESTAMP(10) NOT NULL
);

ALTER TABLE rented_instrument ADD CONSTRAINT PK_rented_instrument PRIMARY KEY (person_id,instrument_id);


DROP TABLE IF EXISTS skill_level CASCADE;
CREATE TABLE skill_level (
 skill_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 skill_level VARCHAR(500) NOT NULL
);

ALTER TABLE skill_level ADD CONSTRAINT PK_skill_level PRIMARY KEY (skill_id);


DROP TABLE IF EXISTS instructor CASCADE;
CREATE TABLE instructor (
 instructor_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 salary INT NOT NULL,
 person_id INT NOT NULL
);

ALTER TABLE instructor ADD CONSTRAINT PK_instructor PRIMARY KEY (instructor_id);


DROP TABLE IF EXISTS student_lesson CASCADE;
CREATE TABLE student_lesson (
 person_id INT NOT NULL,
 lesson_id INT NOT NULL
);

ALTER TABLE student_lesson ADD CONSTRAINT PK_student_lesson PRIMARY KEY (person_id,lesson_id);


DROP TABLE IF EXISTS lesson CASCADE;
CREATE TABLE lesson (
 lesson_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 time TIMESTAMP(10) NOT NULL,
 discount_rate INT,
 instructor_id INT NOT NULL,
 cost_id INT NOT NULL
);

ALTER TABLE lesson ADD CONSTRAINT PK_lesson PRIMARY KEY (lesson_id);


DROP TABLE IF EXISTS price CASCADE;
CREATE TABLE price (
 cost_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 cost INT NOT NULL,
 lesson_type VARCHAR(500) NOT NULL,
 time_of_price TIMESTAMP(10) NOT NULL,
 skill_id INT
);

ALTER TABLE price ADD CONSTRAINT PK_price PRIMARY KEY (cost_id);


DROP TABLE IF EXISTS time_available CASCADE;
CREATE TABLE time_available (
 instructor_id INT NOT NULL,
 available_time_slot_start TIMESTAMP(10) NOT NULL,
 available_time_slot_end TIMESTAMP(10) NOT NULL,
 skill_id INT NOT NULL,
 instrument_type_id INT NOT NULL
);

ALTER TABLE time_available ADD CONSTRAINT PK_time_available PRIMARY KEY (instructor_id);


DROP TABLE IF EXISTS ensemble CASCADE;
CREATE TABLE ensemble (
 lesson_id INT NOT NULL,
 max_student INT NOT NULL,
 min_student INT NOT NULL
);

ALTER TABLE ensemble ADD CONSTRAINT PK_ensemble PRIMARY KEY (lesson_id);


DROP TABLE IF EXISTS group_lesson CASCADE;
CREATE TABLE group_lesson (
 lesson_id INT NOT NULL,
 max_student INT NOT NULL,
 min_student INT NOT NULL,
 instrument_type_id INT NOT NULL
);

ALTER TABLE group_lesson ADD CONSTRAINT PK_group_lesson PRIMARY KEY (lesson_id);


DROP TABLE IF EXISTS individual_lesson CASCADE;
CREATE TABLE individual_lesson (
 lesson_id INT NOT NULL,
 instrument_type_id INT NOT NULL
);

ALTER TABLE individual_lesson ADD CONSTRAINT PK_individual_lesson PRIMARY KEY (lesson_id);


DROP TABLE IF EXISTS target_genre CASCADE;
CREATE TABLE target_genre (
 target_genre VARCHAR(500) NOT NULL,
 lesson_id INT NOT NULL
);

ALTER TABLE target_genre ADD CONSTRAINT PK_target_genre PRIMARY KEY (target_genre,lesson_id);



ALTER TABLE phone_person ADD CONSTRAINT FK_phone_person_0 FOREIGN KEY (person_id) REFERENCES person (person_id) ON DELETE CASCADE;
ALTER TABLE phone_person ADD CONSTRAINT FK_phone_person_1 FOREIGN KEY (phone_id) REFERENCES phone_number (phone_id) ON DELETE CASCADE;

ALTER TABLE address_person ADD CONSTRAINT FK_address_person_0 FOREIGN KEY (person_id) REFERENCES person (person_id) ON DELETE CASCADE;
ALTER TABLE address_person ADD CONSTRAINT FK_address_person_1 FOREIGN KEY (address_id) REFERENCES home_address (address_id) ON DELETE CASCADE;

ALTER TABLE email_person ADD CONSTRAINT FK_email_person_0 FOREIGN KEY (person_id) REFERENCES person (person_id) ON DELETE CASCADE;
ALTER TABLE email_person ADD CONSTRAINT FK_email_person_1 FOREIGN KEY (email_id) REFERENCES email (email_id) ON DELETE CASCADE;


ALTER TABLE student ADD CONSTRAINT FK_student_0 FOREIGN KEY (person_id) REFERENCES person (person_id) ON DELETE CASCADE;

ALTER TABLE student_lesson ADD CONSTRAINT FK_student_lesson_0 FOREIGN KEY (person_id) REFERENCES student (person_id) ON DELETE CASCADE;
ALTER TABLE student_lesson ADD CONSTRAINT FK_student_lesson_1 FOREIGN KEY (lesson_id) REFERENCES lesson (lesson_id) ON DELETE CASCADE;


ALTER TABLE lesson ADD CONSTRAINT FK_lesson_0 FOREIGN KEY (instructor_id) REFERENCES instructor (instructor_id) ON DELETE CASCADE;
ALTER TABLE lesson ADD CONSTRAINT FK_lesson_1 FOREIGN KEY (cost_id) REFERENCES price (cost_id) ON DELETE CASCADE;

ALTER TABLE group_lesson ADD CONSTRAINT FK_group_lesson_0 FOREIGN KEY (lesson_id) REFERENCES lesson (lesson_id) ON DELETE CASCADE;
ALTER TABLE group_lesson ADD CONSTRAINT FK_group_lesson_1 FOREIGN KEY (instrument_type_id) REFERENCES instrument_type (instrument_type_id) ON DELETE CASCADE;

ALTER TABLE individual_lesson ADD CONSTRAINT FK_individual_lesson_0 FOREIGN KEY (lesson_id) REFERENCES lesson (lesson_id) ON DELETE CASCADE;
ALTER TABLE individual_lesson ADD CONSTRAINT FK_individual_lesson_1 FOREIGN KEY (instrument_type_id) REFERENCES instrument_type (instrument_type_id) ON DELETE CASCADE;

ALTER TABLE ensemble ADD CONSTRAINT FK_ensemble_0 FOREIGN KEY (lesson_id) REFERENCES lesson (lesson_id) ON DELETE CASCADE;
ALTER TABLE target_genre ADD CONSTRAINT FK_target_genre_0 FOREIGN KEY (lesson_id) REFERENCES ensemble (lesson_id) ON DELETE CASCADE;


ALTER TABLE instructor ADD CONSTRAINT FK_instructor_0 FOREIGN KEY (person_id) REFERENCES person (person_id) ON DELETE CASCADE;

ALTER TABLE instrument ADD CONSTRAINT FK_instrument_0 FOREIGN KEY (instrument_type_id) REFERENCES instrument_type (instrument_type_id) ON DELETE SET NULL;

ALTER TABLE price ADD CONSTRAINT FK_price_0 FOREIGN KEY (skill_id) REFERENCES skill_level (skill_id) ON DELETE SET NULL;


ALTER TABLE rented_instrument ADD CONSTRAINT FK_rented_instrument_0 FOREIGN KEY (person_id) REFERENCES student (person_id) ON DELETE CASCADE;
ALTER TABLE rented_instrument ADD CONSTRAINT FK_rented_instrument_1 FOREIGN KEY (instrument_id) REFERENCES instrument (instrument_id) ON DELETE CASCADE;


ALTER TABLE time_available ADD CONSTRAINT FK_time_available_0 FOREIGN KEY (instructor_id) REFERENCES instructor (instructor_id) ON DELETE CASCADE;
ALTER TABLE time_available ADD CONSTRAINT FK_time_available_1 FOREIGN KEY (skill_id) REFERENCES skill_level (skill_id) ON DELETE CASCADE;
ALTER TABLE time_available ADD CONSTRAINT FK_time_available_2 FOREIGN KEY (instrument_type_id) REFERENCES instrument_type (instrument_type_id) ON DELETE CASCADE;


