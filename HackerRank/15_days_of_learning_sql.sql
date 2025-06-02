WITH t1 AS (SELECT submission_date,
                   COUNT(DISTINCT hacker_id) AS unique_sub
            FROM Submissions AS s
            WHERE (SELECT COUNT(DISTINCT submission_date)
                   FROM Submissions
                   WHERE hacker_id = s.hacker_id
                         AND
                         submission_date < s.submission_date)
                         = DATEDIFF(s.submission_date, '2016-03-01')
            GROUP BY submission_date),

t2 AS  (SELECT submission_date,
                (SELECT hacker_id
                 FROM Submissions
                 WHERE submission_date = s.submission_date
                 GROUP BY hacker_id
                 ORDER BY COUNT(submission_id) DESC, hacker_id
                 LIMIT 1
                 ) AS hacker_id
        FROM (SELECT DISTINCT submission_date 
              FROM Submissions) AS s
        ORDER BY submission_date)
        
SELECT t1.submission_date,
       t1.unique_sub,
       t2.hacker_id,
       t3.name
FROM t1
JOIN t2 
    ON t1.submission_date = t2.submission_date
JOIN Hackers AS t3
    ON t3.hacker_id = t2.hacker_id
ORDER BY t1.submission_date;