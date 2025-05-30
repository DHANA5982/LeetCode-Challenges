SELECT 
    c.contest_id,
    c.hacker_id,
    c.name,
    COALESCE(SUM(ss.total_submissions), 0) AS total_submissions,
    COALESCE(SUM(ss.total_accepted_submissions), 0) AS total_accepted_submissions,
    COALESCE(SUM(vs.total_views), 0) AS total_views,
    COALESCE(SUM(vs.total_unique_views), 0) AS total_unique_views
FROM contests c
JOIN colleges co ON c.contest_id = co.contest_id
JOIN challenges ch ON co.college_id = ch.college_id
LEFT JOIN (
    SELECT 
        challenge_id, 
        SUM(total_submissions) AS total_submissions,
        SUM(total_accepted_submissions) AS total_accepted_submissions
    FROM submission_stats
    GROUP BY challenge_id
) ss ON ch.challenge_id = ss.challenge_id
LEFT JOIN (
    SELECT 
        challenge_id, 
        SUM(total_views) AS total_views,
        SUM(total_unique_views) AS total_unique_views
    FROM view_stats
    GROUP BY challenge_id
) vs ON ch.challenge_id = vs.challenge_id
GROUP BY c.contest_id, c.hacker_id, c.name
HAVING 
    total_submissions > 0 OR
    total_accepted_submissions > 0 OR
    total_views > 0 OR
    total_unique_views > 0
ORDER BY c.contest_id;