-- For query 1: Shows the number of lessons given per month during a specified year.
SELECT 
    TO_CHAR(time, 'Mon') AS "Month",
    COUNT(*) AS "Total",
    SUM(CASE WHEN lesson_id IN (SELECT lesson_id FROM individual_lesson) THEN 1 ELSE 0 END) AS "Individual",
    SUM(CASE WHEN lesson_id IN (SELECT lesson_id FROM group_lesson) THEN 1 ELSE 0 END) AS "Group",
    SUM(CASE WHEN lesson_id IN (SELECT lesson_id FROM ensemble) THEN 1 ELSE 0 END) AS "Ensemble"
FROM lesson
WHERE EXTRACT(YEAR FROM time) = 2024
GROUP BY TO_CHAR(time, 'Mon'), EXTRACT(MONTH FROM time)
ORDER BY EXTRACT(MONTH FROM time);


-- For query 2 (shows correct output, but not the one shown on Canvas)
SELECT
    SUM(CASE WHEN count = 1 THEN 1 ELSE 0 END) AS "Has 0 siblings",
    SUM(CASE WHEN count = 2 THEN 1 ELSE 0 END) AS "Has 1 sibling",
    SUM(CASE WHEN count = 3 THEN 1 ELSE 0 END) AS "Has 2 siblings"
FROM (
        SELECT sibling_id, COUNT(person_id) AS count 
        FROM student 
        GROUP BY sibling_id
    );

-- Subquery used.
SELECT sibling_id, COUNT(person_id) AS count FROM student GROUP BY sibling_id;

-- Complete query 2 (from help of ChatGPT lol)
SELECT 
    sibling_count AS "Number of siblings",
    COUNT(*) AS "Number of students"
FROM (
    SELECT 
        sibling_id,
        COUNT(person_id) - 1 AS sibling_count -- Subtract 1 to represent the number of siblings
    FROM student
    GROUP BY sibling_id
)
WHERE sibling_count BETWEEN 0 AND 2
GROUP BY sibling_count
ORDER BY sibling_count ASC;




-- For query 3
SELECT 
    subquery.instructor_id,
    person.first_name,
    person.last_name,
    COUNT(subquery.instructor_id)
FROM
    person,
    (
        SELECT 
            person_id,
            instructor.instructor_id
        FROM 
            instructor
        INNER JOIN 
            lesson
        ON
            lesson.instructor_id = instructor.instructor_id
        WHERE 
            EXTRACT(YEAR FROM lesson.time) = 2024 
                AND 
            EXTRACT (MONTH FROM lesson.time) = 11
    ) AS subquery
WHERE
    person.person_id = subquery.person_id
GROUP BY
    subquery.instructor_id, person.first_name, person.last_name;

-- Outputs all instructor_id values from every lesson made in November 2024.
SELECT instructor_id FROM lesson
WHERE EXTRACT(YEAR FROM time) = 2024 AND EXTRACT (MONTH FROM time) = 11; -- Take only results from Nov. 2024



SELECT 
    i.instructor_id,
    p.first_name,
    p.last_name,
    COUNT(l.lesson_id) AS lesson_count
FROM 
    person AS p
INNER JOIN instructor AS i
    ON p.person_id = i.person_id
INNER JOIN lesson  AS l
    ON i.instructor_id = l.instructor_id
WHERE 
    EXTRACT(YEAR FROM l.time) = 2024
    AND EXTRACT(MONTH FROM l.time) = 11
GROUP BY 
    i.instructor_id, p.first_name, p.last_name
ORDER BY 
    lesson_count DESC; -- Optional: Orders results by lesson count



--Testing query 3
SELECT 
    i.instructor_id,
    p.first_name,
    p.last_name,
    COUNT(l.lesson_id) AS lesson_count,
    EXTRACT(MONTH FROM l.time)
FROM 
    person AS p
INNER JOIN instructor AS i
    ON p.person_id = i.person_id
INNER JOIN lesson  AS l
    ON i.instructor_id = l.instructor_id
WHERE 
    EXTRACT(YEAR FROM l.time) = 2024
    --AND EXTRACT(MONTH FROM l.time) = 11
GROUP BY 
    i.instructor_id, p.first_name, p.last_name, l.time
ORDER BY 
    l.time DESC; -- Optional: Orders results by lesson count

--Inserting more test data
INSERT INTO lesson (time, instructor_id, cost_id) VALUES
('2024-11-22 19:10:25-07', 3, 1),
('2024-11-22 18:10:25-07', 3, 1),
('2024-11-22 17:10:25-07', 3, 1);

SELECT time FROM lesson WHERE instructor_id = 3;




-- query 4:
SELECT 
    ......
WHERE 
    EXTRACT(YEAR FROM time) = 2024
    AND EXTRACT(MONTH FROM time) = 11
    AND EXTRACT(DAY FROM time) BETWEEN 1 AND 7
GROUP BY 
    i.instructor_id, p.first_name, p.last_name
ORDER BY 
    lesson_count DESC; -- Optional: Orders results by lesson count


--Version 1
SELECT 
    TO_CHAR(l.time, 'Dy') AS "Day",
    t.target_genre AS "Genre",
    CASE 
        -- Must find how many students take one lesson
        WHEN COUNT(res.student_id) = e.max_student THEN "No Seats"
        WHEN COUNT(res.student_ID) BETWEEN (e.max_student-2) AND e.max_student THEN "1 or 2 Seats"
        ELSE "More Seats"
    END AS "Nr of Free Seats"
FROM 
    lesson AS l
INNER JOIN
    ensemble AS e
ON
    l.lesson_id = e.lesson_id
INNER JOIN
    target_genre AS t
ON
    e.lesson_id = t.lesson_id;
WHERE 
    EXTRACT(YEAR FROM l.time) = 2024
    AND EXTRACT(MONTH FROM l.time) = 11
    AND EXTRACT(DAY FROM l.time) BETWEEN 1 AND 30;




--Version 2
SELECT 
    TO_CHAR(l.time, 'Dy') AS "Day",
    t.target_genre AS "Genre",
    CASE 
        WHEN COUNT(s.person_id) = e.max_student THEN "No Seats"
        WHEN COUNT(s.person_id) BETWEEN (e.max_student-2) AND e.max_student THEN "1 or 2 Seats"
        ELSE "More Seats"
    END AS "Nr of Free Seats"
FROM 
    lesson AS l
INNER JOIN
    ensemble AS e
ON
    l.lesson_id = e.lesson_id
INNER JOIN
    target_genre AS t
ON
    e.lesson_id = t.lesson_id
INNER JOIN
    student_lesson AS s
ON
    s.lesson_id = e.lesson_id
WHERE 
    time >= CURRENT_DATE
    AND time < CURRENT_DATE + INTERVAL '1 year'
GROUP BY s.student_id;



--Version 3, completed (through ChatGPT lol)
SELECT 
    TO_CHAR(l.time, 'Dy') AS "Day",
    t.target_genre AS "Genre",
    CASE 
        WHEN COUNT(s.person_id) = e.max_student THEN 'No Seats'
        WHEN e.max_student - COUNT(s.person_id) BETWEEN 1 AND 2 THEN '1 or 2 Seats'
        ELSE 'Many Seats'
    END AS "Number of Free Seats"
FROM 
    lesson AS l
INNER JOIN ensemble AS e
    ON l.lesson_id = e.lesson_id
INNER JOIN target_genre AS t
    ON e.lesson_id = t.lesson_id
LEFT JOIN student_lesson AS s
    ON s.lesson_id = l.lesson_id
WHERE 
    l.time >= CURRENT_DATE 
    AND l.time < CURRENT_DATE + INTERVAL '1 week'
GROUP BY 
    l.time, t.target_genre, e.max_student
ORDER BY 
    l.time;





--                                         FOR TESTING QUERY 3
INSERT INTO lesson (time, instructor_id, cost_id) VALUES
('2024-11-29 19:10:25-07', 3, 1),
('2024-11-30 18:10:25-07', 3, 1),
('2024-12-01 17:10:25-07', 3, 1);

SELECT time, TO_CHAR(time, 'Dy') AS "Day"
FROM lesson
WHERE lesson_id BETWEEN 107 AND 109
ORDER BY lesson_id ASC;


INSERT INTO ensemble VALUES
(107, 3, 1),
(108, 4, 1),
(109, 2, 1);

INSERT INTO target_genre VALUES
('Jazz', 107),
('Jazz', 108),
('Rock', 109);


INSERT INTO student_lesson VALUES
(1, 107),
(2, 107),
(3, 108),
(4, 109),
(5, 109);


-- Find how many students take ensemble-lessons
SELECT s.person_id
FROM student_lesson s
INNER JOIN lesson l ON s.lesson_id = l.lesson_id
INNER JOIN ensemble e ON e.lesson_id = s.lesson_id
INNER JOIN target_genre t ON t.lesson_id = e.lesson_id
WHERE EXTRACT(DAY FROM l.time) BETWEEN 1 AND 30   AND EXTRACT(MONTH FROM l.time) = 11
ORDER BY lesson_id ASC;

-- Query 3: Find how many students take ONE ensemble-lessons
SELECT s.person_id
FROM student_lesson s
INNER JOIN lesson l ON s.lesson_id = l.lesson_id
INNER JOIN ensemble e ON e.lesson_id = s.lesson_id
INNER JOIN target_genre t ON t.lesson_id = e.lesson_id
WHERE 
    time >= CURRENT_DATE
    AND time < CURRENT_DATE + INTERVAL '1 week';

--I dunno
SELECT COUNT(*)
FROM student_lesson s
INNER JOIN lesson l ON s.lesson_id = l.lesson_id
INNER JOIN ensemble e ON e.lesson_id = s.lesson_id
INNER JOIN target_genre t ON t.lesson_id = e.lesson_id
WHERE 
    time >= CURRENT_DATE
    AND time < CURRENT_DATE + INTERVAL '1 week'
GROUP BY s.person_id;
